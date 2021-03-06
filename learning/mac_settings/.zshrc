# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# export DYLD_LIBRARY_PATH=/opt/X11/lib/flat_namespace
export PATH=$PATH:/Applications/MATLAB_R2016b.app/bin/:/Users/mac/Library/Python/2.7/bin:/Users/mac/nethack4:/Users/mac/anaconda3/envs/psychopy/lib/python3.6/site-packages/mripy/scripts:/Users/mac/laynii:/Users/mac/go/bin/:/Users/mac/abin
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8
export DNNBRAIN_DATA=/Volumes/WD_D/gufei/document/dnnbrain/data
export MATLAB_SHELL=/bin/bash
alias cat="bat"
alias top="htop"
alias f="fuck"
alias matlab="matlab -nodesktop -nosplash"
alias mrun="matlab -nodesktop -nosplash -nodisplay -nojvm -r"
alias du="ncdu -rr -x --exclude .git --exclude node_modules"
alias diff="icdiff"
alias tree="tree -N -C"
alias v="nvim"
# ANTs
export ANTSPATH=/opt/ANTs/bin/
export PATH=${ANTSPATH}:$PATH
# Path to your oh-my-zsh installation.
export ZSH="/Users/mac/.oh-my-zsh"
export TERM="xterm-256color"
export DYLD_LIBRARY_PATH=${DYLD_LIBRARY_PATH}:/opt/X11/lib/flat_namespace
# ffmpeg libffi
#export LDFLAGS="-L/usr/local/opt/libffi/lib"
#export CPPFLAGS="-I/usr/local/opt/libffi/include"
#export PKG_CONFIG_PATH="/usr/local/opt/libffi/lib/pkgconfig"
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="powerline"
#POWERLINE_RIGHT_B="none"
#POWERLINE_HIDE_USER_NAME="true"
#POWERLINE_HIDE_HOST_NAME="true"
#POWERLINE_PATH="short"
#POWERLINE_SHOW_GIT_ON_RIGHT="true"

ZSH_THEME="powerlevel9k/powerlevel9k"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(time anaconda dir )
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status vcs root_indicator background_jobs)
#POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_first_and_last
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git autojump osx brew docker zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/mac/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/mac/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/mac/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/mac/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

conda deactivate

# freesurfer
export FREESURFER_HOME=/Applications/freesurfer/7.1.1
export SUBJECTS_DIR=$FREESURFER_HOME/subjects
export TUTORIAL_DATA=/Volumes/WD_D/share/tutorial_data_20190918_1558
source $FREESURFER_HOME/SetUpFreeSurfer.sh > /dev/null
# dictionary
v2() {
  declare q="$*";
  curl --user-agent curl "https://v2en.co/${q// /%20}";
}

v2-sh() {
  while echo -n "v2en> ";
  read -r input;
  [[ -n "$input" ]];
  do v2 "$input";
  done;
}

#[[-s $(brew --prefix)/etc/profile.d/autojump.sh]]&&.$(brew --prefix)/etc/profile.d/autojump.sh
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="/usr/local/opt/ruby/bin:$PATH"
PATH="$PATH:/usr/local/lib/ruby/gems/2.7.0/gems/jekyll-4.0.0/exe:/Users/mac/.cargo/bin"
#:/usr/local/Cellar/ruby/2.7.1_2/lib/ruby/gems/2.7.0/gems/"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval $(thefuck --alias)
export PATH="/usr/local/sbin:$PATH"

# auto-inserted by @update.afni.binaries :
#    set up tab completion for AFNI programs
if [ -f $HOME/.afni/help/all_progs.COMP.zsh ]
then
   autoload -U +X bashcompinit && bashcompinit
   autoload -U +X compinit && compinit \
      && source $HOME/.afni/help/all_progs.COMP.zsh
fi

