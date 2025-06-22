# ==============================================================================
# 🔒 PROJECT JAIL SYSTEM
# ==============================================================================
check_path()
{
    local path="$1"
    if [[ -z "$path" ]]; then
        path="$PWD"
    fi
    
    local real_path=$(realpath "$path" 2>/dev/null)
    local real_root=$(realpath "$PROJECT_ROOT")
    
    if [[ "$real_path" == "$real_root"* ]]; then
        return 0
    else
        echo "Access denied: Outside project root"
        return 1
    fi
}

# ------------------------------------------------------------------------------
# Navigation Override: cd command
# ------------------------------------------------------------------------------
cd()
{
    if [[ $# -eq 0 ]]; then
        builtin cd "$PROJECT_ROOT"
        return
    fi
    
    local target="$1"
    case "$target" in
        ".")
            return 0
            ;;
        "..")
            if [[ "$PWD" == "$PROJECT_ROOT" ]]; then
                return 0
            fi
            local parent=$(dirname "$PWD")
            if check_path "$parent"; then
                builtin cd "$parent"
            fi
            ;;
        /*)
            if check_path "$target"; then
                builtin cd "$target"
            fi
            ;;
        *)
            local full_path="$PWD/$target"
            if check_path "$full_path"; then
                builtin cd "$target"
            fi
            ;;
    esac
}

# ------------------------------------------------------------------------------
# Command Overrides: ls, pwd
# ------------------------------------------------------------------------------

HIDDEN_ITEMS=(
    ".project.env"
    "Makefile"
    ".tmp"
    ".git"
    ".gitignore"
    ".vscode"
    ".envrc"
    "shell.nix"
    "bootstrap"
    "README.md"
)

override_ls()
{
    if check_path; then
        local output
        output=$(command ls "$@" 2>/dev/null)
        local filtered_output=""

        while IFS= read -r line; do
            local should_hide=false
            local filename="$line"
            if [[ "$*" == *"-l"* ]]; then
                filename=$(echo "$line" | awk '{print $NF}')
            fi
            for hidden_item in "${HIDDEN_ITEMS[@]}"; do
                if [[ "$filename" == "$hidden_item" ]]; then
                    should_hide=true
                    break
                fi
            done
            if [[ "$should_hide" == false ]]; then
                filtered_output+="$line"$'\n'
            fi
        done <<< "$output"

        echo -n "$filtered_output"
    fi
}

override_pwd()
{
    local current=$(builtin pwd)
    if [[ "$current" == "$PROJECT_ROOT" ]]; then
        echo "/"
    else
        echo "${current#$PROJECT_ROOT}"
    fi
}
