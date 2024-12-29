from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import os
import hashlib

app = FastAPI()

NFS_CONFIG_PATH = "/etc/exports"

class CreateFolderRequest(BaseModel):
    folder_name: str
    mount_location: str
    md5: str | None = None
    sha1: str | None = None

@app.post("/create-folder")
async def create_folder(request: CreateFolderRequest):
    folder_path = os.path.join("/mnt/jobfile-run", request.folder_name)

    # Check if the folder already exists
    if os.path.exists(folder_path):
        raise HTTPException(status_code=400, detail="Folder already exists")

    # Create the folder
    try:
        os.makedirs(folder_path, exist_ok=True)
        os.chmod(folder_path, 0o777)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to create folder: {str(e)}")

    # Update the NFS configuration file
    try:
        with open(NFS_CONFIG_PATH, "a") as nfs_config:
            nfs_config.write(f"{folder_path} {request.mount_location}(rw,sync,no_root_squash)\n")
    except Exception as e:
        os.rmdir(folder_path)  # Roll back folder creation
        raise HTTPException(status_code=500, detail=f"Failed to update NFS config: {str(e)}")

    # Validate the folder if MD5 or SHA1 hash is provided
    if request.md5 or request.sha1:
        try:
            with open(folder_path, "wb") as test_file:
                test_file.write(b"test")
            with open(folder_path, "rb") as test_file:
                file_data = test_file.read()

            if request.md5 and hashlib.md5(file_data).hexdigest() != request.md5:
                os.rmdir(folder_path)
                raise HTTPException(status_code=400, detail="MD5 hash mismatch")

            if request.sha1 and hashlib.sha1(file_data).hexdigest() != request.sha1:
                os.rmdir(folder_path)
                raise HTTPException(status_code=400, detail="SHA1 hash mismatch")
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"Hash validation failed: {str(e)}")

    return {"folder_name": request.folder_name, "mount_location": request.mount_location}
