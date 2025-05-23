#!/bin/bash


# Welcome message with ASCII art
cat << "EOF"
.____                 .__               
|    |    ____   ____ |__| ____   ____  
|    |  _/ __ \ / ___\|  |/  _ \ /    \ 
|    |__\  ___// /_/  >  (  <_> )   |  \
|_______ \___  >___  /|__|\____/|___|  /
        \/   \/_____/                \/ 
Welcome to LEGION's environment!
EOF
sleep 5

if command -v brew >/dev/null 2>&1; then
  echo "✅ Homebrew is installed."
else
  echo "💡Homebrew is not installed. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install Zsh and Oh My Zsh
if command -v zsh >/dev/null 2>&1; then
  echo "✅ Zsh is installed."
else
  echo "💡Zsh is not installed. Installing Zsh..."
  brew install zsh
fi

# Installing basic dependencies
if ! command -v nvim &> /dev/null; then
    echo "💡Installing nvim..."
    brew install nvim
else
    echo "✅ nvim is already installed."
fi

if ! command -v rg &> /dev/null; then
    echo "💡Installing ripgrep..."
    brew install ripgrep
else
    echo "✅ ripgrep is already installed."
fi

if ! command -v lsd &> /dev/null; then
    echo "💡Installing lsd..."
    brew install lsd
else
    echo "✅ lsd is already installed."
fi

echo "alias ls='lsd -hA --group-dirs first'" >> ~/.zshrc
echo "alias fix-perms='sudo chown -R $(whoami):$(whoami) $(pwd)'" >> ~/.zshrc
echo "🚀 installing NvChad... 💪🏻"
git clone https://github.com/NvChad/starter ~/.config/nvim

# copying custom 
echo "💡Copying custom configuration files..."
SOURCE_DIR="$HOME/dotfiles/devcontainer/nvchad/personal/"
DEST_DIR="$HOME/.config/nvim/lua/custom/"

# Create the destination directory if it doesn't exist
mkdir -p "$DEST_DIR"
# Copy the content from SOURCE_DIR to DEST_DIR
cp -r "$SOURCE_DIR"/* "$DEST_DIR"

echo "Content copied from $SOURCE_DIR to $DEST_DIR"

# copying functions
mkdir -p ~/.config/nvim/lua/functions/
cp -r ~/dotfiles/devcontainer/nvchad/functions/* ~/.config/nvim/lua/functions/

# copying options 
echo "💡Copying options configuration files..."
echo "require \"nvchad.mappings\"" > ~/.config/nvim/lua/mappings.lua
echo "require \"custom\"" >> ~/.config/nvim/lua/mappings.lua
echo "local map = vim.keymap.set" >> ~/.config/nvim/lua/mappings.lua
echo "map(\"n\", \"<leader>tch\", \"<cmd>Telescope keymaps<cr>\", { desc = \"Telescope nvcheatsheet\" })" >> ~/.config/nvim/lua/mappings.lua
echo "vim.cmd(\"set clipboard+=unnamedplus\")" >> ~/.config/nvim/lua/options.lua
echo "vim.cmd(\"set number relativenumber\")" >> ~/.config/nvim/lua/options.lua
echo "vim.cmd(\"set numberwidth=1\")" >> ~/.config/nvim/lua/options.lua
echo "vim.opt.scrolloff = 8" >> ~/.config/nvim/lua/options.lua
echo "vim.opt.wrap = false" >> ~/.config/nvim/lua/options.lua

echo "added options to mappings and options files"

# copying plugins
echo "💡Copying plugins configuration files..."
PLUGINS_SOURCE_DIR="$HOME/dotfiles/luavim/lua/plugins"
PLUGINS_DEST_DIR="$HOME/.config/nvim/lua/plugins/"

PLUGINS_LIST = (
  "copilot",
  "harpoon",
  "linter_and_formatter",
  "smooth_scroll",
  "start_screen"
)
for plugin in "${PLUGINS_LIST[@]}"; do
    cp "$PLUGINS_SOURCE_DIR/${plugin}.lua" "$PLUGINS_DEST_DIR"
done
cp ~/dotfiles/devcontainer/nvchad/plugins/init.lua "$PLUGINS_DEST_DIR"

echo "added plugins"


cat << "EOF"
 ___________   ____        .____                 .__               
 \      \   \ /   /        |    |    ____   ____ |__| ____   ____  
 /   |   \   Y   /  ______ |    |  _/ __ \ / ___\|  |/  _ \ /    \ 
/    |    \     /  /_____/ |    |__\  ___// /_/  >  (  <_> )   |  \
\____|__  /\___/           |_______ \___  >___  /|__|\____/|___|  /
        \/                         \/   \/_____/                \/ 

*******************************************************************
                 [Welcome to LEGION's environment!] 
                      *powered by NvChad*

*******************************************************************
[INFO] You can now start using Neovim it will automatically install the plugins for you.
[INFO] Please run the following commands inside neovim to finish the installation:
- :Copilot auth
- :MasonInstallAll

EOF
