# 🛠️ Project Workspace Template for VS Code

This project uses a custom `.bashrc.vscode` script to create an isolated, secure, and developer-friendly environment inside the VS Code terminal.

---

## ✅ Features

- Safe project-scoped `cd`, `ls`, and `pwd` overrides
- Git and navigation shortcuts
- Auto-loaded `.env` support
- SSH key integration
- Custom terminal prompt
- Works automatically inside VS Code terminal sessions

---

## ⚙️ Setup Instructions

Before using this project template, you need to add the following script to your global `~/.bashrc` file. This enables:

- SSH key support for Git
- Automatic loading of `.bashrc.vscode` when opening a terminal in VS Code

### 📝 Step 1: Edit `~/.bashrc`

Open your terminal and run:

```bash
nano ~/.bashrc
```

Or use your preferred text editor.

### 🧩 Step 2: Add the following block to the bottom of the file:

```bash
# ========================
# VS Code Project Autoload
# ========================

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

# Auto-load project-specific .bashrc if inside VS Code terminal
if [[ "$TERM_PROGRAM" == "vscode" ]]; then
    d="$PWD"
    while [[ "$d" != "/" ]]; do
        [[ -f "$d/.bashrc.vscode" ]] && source "$d/.bashrc.vscode" && break
        d=$(dirname "$d")
    done
fi
```

> 💡 Tip: Replace `id_ed25519` with your actual SSH private key filename if it's different.

### 💾 Step 3: Save and Apply

After editing, apply the changes by running:

```bash
source ~/.bashrc
```

Now every time you open a terminal in VS Code inside this project, it will automatically load the `.bashrc.vscode` environment!

---

## 🧪 Test It

1. Open this project folder in **VS Code**.
2. Open a new terminal.
3. You should see the welcome message and restricted environment.

---

## 📁 Example Project Layout

```
your-project/
├── .bashrc.vscode
├── bin/
├── scripts/
├── .env
└── README.md
```

---

## 🔐 Security

This setup ensures:
- You never accidentally run commands outside the project directory
- No hardcoded sensitive values inside `.bashrc.vscode`
- Your SSH key is only added when needed

---

## 📬 Questions?

Feel free to customize the `.bashrc.vscode` file for your specific tech stack (Node.js, Python, Go, Docker, etc.).

---
