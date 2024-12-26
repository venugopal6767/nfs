# Makefile to create NFS users

SECRETS_DIR = ./secrets
USER_FILE = ../secets.nfs.txt

# List of users to create in the NFS server
USERS = user1 user2 user
# Create the secrets directory and the user file
secrets:
	@mkdir -p $(SECRETS_DIR)
	@echo "Creating secrets file: $(USER_FILE)"
	@for user in $(USERS); do \
		echo $$user >> $(USER_FILE); \
	done
	@echo "Secrets file created at: $(USER_FILE)"

.PHONY: secrets
