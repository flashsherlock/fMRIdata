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
# ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null 2> /dev/null
# install applications
brew install vim neovim tree thefuck bat mc ncdu htop axel wget fzf tig autojump fortune cowsay
# install to /Users/olfmac/anaconda3
brew install homebrew/cask/anaconda
brew install homebrew/cask/docker
brew install netpbm gfortran tmux go go-md2man docker visual-studio-code microsoft-edge

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

# afni https://afni.nimh.nih.gov/pub/dist/doc/htmldoc/background_install/install_instructs/steps_mac.html
defaults write org.macosforge.xquartz.X11 wm_ffm -bool true
defaults write org.x.X11 wm_ffm -bool true
defaults write com.apple.Terminal FocusFollowsMouse -string YES
# install xquartz from http://www.xquartz.org
# download and install
cd ~
curl -O https://afni.nimh.nih.gov/pub/dist/bin/misc/@update.afni.binaries
tcsh @update.afni.binaries -package macos_10.12_local -do_extras
# or use local packages
# tcsh @update.afni.binaries -local_package PATH_TO_FILE/macos_10.12_local.tgz -do_extras
cp $HOME/abin/AFNI.afnirc $HOME/.afnirc
suma -update_env
# then reboot
# install examples
curl -O https://afni.nimh.nih.gov/pub/dist/edu/data/CD.tgz
tar xvzf CD.tgz
cd CD
tcsh s2.cp.files . ~
cd ..
# check
afni_system_check.py -check_all

# fsl
python fslinstaller.py

# hostname and computername
scutil --get LocalHostName
scutil --get ComputerName
sudo scutil --set HostName MacPro
# hostname will echo MacPro
hostname

# install R and create softlink
ln -s /Library/Frameworks/R.framework/Resources/bin/R /usr/local/bin/R
ln -s /Library/Frameworks/R.framework/Resources/bin/Rscript /usr/local/bin/Rscript
@afni_R_package_install -shiny -circos
#安装updateR
install_github('andreacirilloac/updateR')
library(updateR) 
#更新
updateR()
install.packages("devtools","tidyverse","ggstatsplot")
devtools::install_github("psychbruce/bruceR")