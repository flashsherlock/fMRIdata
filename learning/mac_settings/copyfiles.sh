scp mac@192.168.20.251:~/.tcshrc ./
scp mac@192.168.20.251:~/.zshrc ./
scp mac@192.168.20.251:~/.vimrc ./
scp -r mac@192.168.20.251:~/.vim ./
scp -r mac@192.168.20.251:~/.oh-my-zsh ./
pip3 install powerline-shell
scp -r mac@192.168.20.251:~/.config/powerline-shell ./
scp mac@192.168.20.251:~/.fzf.zsh ./
scp mac@192.168.20.251:~/.ssh/authorized_keys ~/.ssh/

# allow all app sources
sudo spctl --master-disable
# install xcode command line tool
xcode-select --install
# install homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# install applications
brew install vim neovim tree thefuck bat mc ncdu htop axel wget fzf tig autojump fortune cowsay
# install to /Users/olfmac/anaconda3
brew install homebrew/cask/anaconda
brew install homebrew/cask/docker
brew install tmux go go-md2man docker visual-studio-code microsoft-edge

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# powerline-shell
conda activate
pip install powerline-shell
mkdir -p ~/.config/powerline-shell && \
powerline-shell --generate-config > ~/.config/powerline-shell/config.json
# vim extension
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# then run :PluginInstall in vim
# install spacevim for neovim
# help file
curl -sLf https://spacevim.org/cn/install.sh | bash -s -- -h
curl -sLf https://spacevim.org/cn/install.sh | bash -s -- --install neovim

# fsl
# python fslinstaller.py

# hostname and computername
scutil --get LocalHostName
scutil --get ComputerName