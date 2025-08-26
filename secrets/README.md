# Sops-nix Integration Setup

This directory contains encrypted secrets managed by sops-nix.

## Initial Setup

1. **Generate age key** (if not already generated):
   ```bash
   mkdir -p ~/.config/sops/age
   age-keygen -o ~/.config/sops/age/keys.txt
   ```

2. **Get your public key**:
   ```bash
   age-keygen -y ~/.config/sops/age/keys.txt
   ```

3. **Update `.sops.yaml`** with your public key:
   Replace the placeholder key in `.sops.yaml` with your actual public key.

4. **Create secrets file**:
   ```bash
   cp secrets.yaml.example secrets.yaml
   # Edit secrets.yaml with your actual values
   ```

5. **Encrypt the secrets file**:
   ```bash
   sops -e -i secrets.yaml
   ```

## Adding New Secrets

To add new secrets, edit the encrypted file:
```bash
sops secrets.yaml
```

Then update `modules/secrets.nix` to define how the new secrets should be exposed to the system.

## GitHub Token Setup

1. Generate a GitHub personal access token at: https://github.com/settings/tokens
2. Required scopes for gh CLI:
   - `repo` (Full control of private repositories)
   - `read:org` (Read org and team membership)
   - `read:public_key` (Read public keys)  
   - `read:repo_hook` (Read repository hooks)
   - `user` (Read/write all user profile data)
   - `delete_repo` (Delete repositories)
   - `notifications` (Access notifications)
   - `gist` (Create gists)

3. Add the token to your `secrets.yaml` file and encrypt it.