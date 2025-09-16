# dotfiles

Configuration files tweaked to my dev environments

## My Setup

* **Terminal Emulator**: [Ghostty](https://ghostty.org)
  * Theme: [Catppuccin](https://github.com/catppuccin/ghostty) dark theme flavor `mocha`, light theme flavor `latte`
  * Font: [nerdfonts](https://www.nerdfonts.com/font-downloads) `CaskaydiaCove Nerd Font` 
  * Configuration: [ghostty/config](.config/ghostty/config)
* **Shell**: [Zsh](https://www.zsh.org/)
  * Prompt: [Oh My Posh](https://ohmyposh.dev/)
  * Plugin Manager: [Zinit](https://github.com/zdharma-continuum/zinit)
    * [fast-syntax-highlighting](https://github.com/zdharma-continuum/fast-syntax-highlighting)
    * [zsh-completions](https://github.com/zsh-users/zsh-completions)
    * [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
    * [fzf-tab](https://github.com/Aloxaf/fzf-tab)
  * Configuration: [.zshrc](.zshrc) and [ohmyposh/zen.toml](ohmyposh/zen.toml)
* **Editor**: [Neovim](https://neovim.io)
  * Plugin Manager: [Lazy.nvim](https://lazy.folke.io)
  * Configuration: [nvim](.config/nvim)
  * Requirements for plugins:
    * [fd](https://github.com/sharkdp/fd) requirement for the telescope plugin
    * [nerdfonts](https://www.nerdfonts.com/font-downloads) `CaskaydiaCove Nerd Font`
* **Command Line Tools**
  * [fd](https://github.com/sharkdp/fd): Simple, fast and user-friendly alternative to find.
  * [fzf](https://github.com/junegunn/fzf): Command-line fuzzy finder.
  * [ripgrep](https://github.com/BurntSushi/ripgrep): Search tool like grep and The Silver Searcher.
  * [zoxide](https://github.com/ajeetdsouza/zoxide): zoxide is a smarter **cd command**, inspired by z and autojump.
* **Terminal Multiplexer**: [tmux](https://github.com/tmux/tmux)
  * Configuration: [tmux/tmux.conf](.config/tmux/tmux.conf)

## Mac Installation
```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo >> ~/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

brew install zsh
chsh -s $(which zsh)

brew install git vim sublime-text

brew install ghostty
brew install tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

brew install --cask font-caskaydia-cove-nerd-font
brew install jandedobbeleer/oh-my-posh/oh-my-posh
brew install neovim

brew install fd
brew install fzf
brew install ripgrep
brew install zoxide
```

## Arch Installation

