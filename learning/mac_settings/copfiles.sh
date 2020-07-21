scp mac@192.168.20.251:~/.tcshrc ./
scp mac@192.168.20.251:~/.zshrc ./
scp mac@192.168.20.251:~/.vimrc ./
scp -r mac@192.168.20.251:~/.vim ./
scp -r mac@192.168.20.251:~/.oh-my-zsh ./
pip3 install powerline-shell
scp -r mac@192.168.20.251:~/.config/powerline-shell ./
scp mac@192.168.20.251:~/.fzf.zsh ./
brew install vim tree thefuck bat mc ncdu htop axel fzf tig autojump
