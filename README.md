```bash
# Variable set for GitHub SSH key
export PROJECT_SSH_KEY="$HOME/.ssh/id_ed25519"

# Start ssh-agent only if not already running, and add key if not loaded
if [[ -n "$PROJECT_SSH_KEY" && -f "$PROJECT_SSH_KEY" ]]; then
    if [[ -z "$SSH_AUTH_SOCK" || ! -S "$SSH_AUTH_SOCK" ]]; then
        eval "$(ssh-agent -s)" > /dev/null
    fi

    if ! ssh-add -l | grep -q "$PROJECT_SSH_KEY"; then
        ssh-add "$PROJECT_SSH_KEY" 2>/dev/null
    fi
fi

```
