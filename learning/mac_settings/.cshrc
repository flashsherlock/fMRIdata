set path=($path ~/abin /sw/bin)
setenv LANG zh_CN.UTF-8
setenv LC_ALL zh_CN.UTF-8
setenv MATLAB_SHELL /bin/bash
#setenv DISPLAY localhost:10.0
test -r /sw/bin/init.csh && source /sw/bin/init.csh

if ( -f $HOME/.afni/help/all_progs.COMP ) then
   source $HOME/.afni/help/all_progs.COMP
endif

if ( $?DYLD_LIBRARY_PATH ) then
  setenv DYLD_LIBRARY_PATH ${DYLD_ZLIBRARY_PATH}:/opt/X11/lib/flat_namespace
else
  setenv DYLD_LIBRARY_PATH /opt/X11/lib/flat_namespace
endif
set filec
set sautolist
set nobeep
alias ls ls -G
alias ll ls -lG
alias ltr ls -lGtr
alias rmi rm -i
alias cpi cp -i
alias mvi mv -i
set histfile = ~/.tcsh_history
set history = 500
set savehist = 200
set correct = cmd
set noclobber
alias precmd 'history -S; history -M'
bindkey -e
#bindkey '\e[3~' delete-char
