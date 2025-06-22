# 🛠 Project Setup (Nix + direnv + SSH Key)

## ✅ 1. Install Required Tools

### 📦 Install Nix
https://nixos.org/download/

### 📦 Install direnv
```bash
# On Ubuntu/Debian
sudo apt install direnv

# Or via Homebrew (Mac/Linux)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install direnv
```

---

## ✅ 2. Enable `direnv` in Your Shell

Add this to the **end of your `~/.bashrc`** (or `~/.zshrc` if using zsh):

```bash
eval "$(direnv hook bash)"
```

Then reload your shell:

```bash
source ~/.bashrc
```

---

## ✅ 3. Setup SSH Key for GitHub

Add this to your `~/.bashrc` or `~/.bash_profile`:

```bash
# 📁 GitHub SSH Key
export PROJECT_SSH_KEY="$HOME/.ssh/id_ed25519"

# 🚀 Start ssh-agent and add key
if [[ -n "$PROJECT_SSH_KEY" && -f "$PROJECT_SSH_KEY" ]]; then
    if [[ -z "$SSH_AUTH_SOCK" || ! -S "$SSH_AUTH_SOCK" ]]; then
        eval "$(ssh-agent -s)" > /dev/null
    fi

    if ! ssh-add -l 2>/dev/null | grep -q "$PROJECT_SSH_KEY"; then
        ssh-add "$PROJECT_SSH_KEY" > /dev/null 2>&1
    fi
fi
```

---

## ✅ 4. Allow Project Environment

Inside your project directory:

```bash
direnv allow
```

> This enables `.envrc` and automatically loads your Nix shell when you `cd` into the project folder.
