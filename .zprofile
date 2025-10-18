


if [ -f "$HOME/.profile" ]; then
    emulate sh -c '. "$HOME/.profile"'
fi

# Check the operating system
case "$(uname -s)" in
  Linux*)
    export PATH="$PATH:$HOME.local/share/JetBrains/Toolbox/scripts"
    ;;
  Darwin*)
    # Added by Toolbox App
    export PATH="$PATH:/Users/Ahmed.Aly/Library/Application Support/JetBrains/Toolbox/scripts"

    eval "$(/opt/homebrew/bin/brew shellenv)"

    # Added by OrbStack: command-line tools and integration
    # This won't be added again if you remove it.
    source ~/.orbstack/shell/init.zsh 2>/dev/null || :
    ssh-add --apple-use-keychain ~/.ssh/id_ed25519
    ;;
  CYGWIN*|MSYS*|MINGW*)
    echo "This is a a Windows-based system (Cygwin/MSYS/MinGW)."
    ;;
  *)
    echo "This is an unknown operating system: $(uname -s)"
    ;;
esac
