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

## Installation

### Mac Installation
```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo >> ~/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
brew bundle install

chsh -s $(which zsh)

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

### Debian Installation
```bash
sudo apt install -y \
    zsh \
    fd-find \
    fzf \
    git \
    git-gui \
    htop \
    tree \
    nmap \
    ripgrep \
    stow \
    tmux \
    vim \
    wget \
    zoxide \
    gimp \
    tree-sitter-cli \
    lazygit \
    nodejs \
    npm \
    pkg-config \
    libssl-dev \
    default-jre \
    default-jdk \
    cargo

curl -s https://ohmyposh.dev/install.sh | bash -s
curl -fsSL https://bun.sh/install | bash
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
curl -LsSf https://astral.sh/ruff/install.sh | sh
curl -LsSf https://astral.sh/uv/install.sh | sh
# Download ghostty from https://github.com/mkasberg/ghostty-ubuntu/releases
sudo apt install ./ghostty_*.deb
mkdir ~/.fonts
# download font and extract into ~/.fonts without a subfolder
fc-cache -fv

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone https://github.com/ahmed-aly-aut/dotfiles.git ~/repositories/dotfiles

#install neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

```

## Deploying Config
```bash
cd ~/repositories/dotfiles
stow --target ~/ . 
```
