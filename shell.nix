# shell.nix

{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell
{
    # Build inputs
    buildInputs = with pkgs; [
        clang
        gdb
    ];

    # Shell hook that run when entering the shell
    shellHook = ''
        # Source .bashrc.vscode
        if [ -f "./.bashrc.vscode" ]; then
            echo "Sourcing .bashrc.vscode..."
            source ./.bashrc.vscode
        else
            echo "Warning: .bashrc.vscode not found in the current directory"
        fi
    '';
}