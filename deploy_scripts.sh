programs="alacritty picom tmux npm nodejs neovim rofi pcmanfm"
sudo pacman -S $programs

configs=($(find "$(pwd)" -maxdepth 1 -type d ! -path "*/startup_scripts" ! -path "*/.git" ! -path "$(pwd)"))

for config in "${configs[@]}"
do
    ln -s "$config" "$HOME/.config"
    echo "linked $config -> $HOME/.config"
done

echo "Installing Vim plug (needed for neovim)"
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

