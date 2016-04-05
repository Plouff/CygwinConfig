# Some example alias instructions
# If these are enabled they will be used instead of any instructions
# they may mask.  For example, alias rm='rm -i' will mask the rm
# application.  To override the alias instruction use a \ before, ie
# \rm will call the real rm not the alias.
#
# Interactive operation...
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
#
# Default to human readable figures
# alias df='df -h'
# alias du='du -h'
#
# Misc :)
alias less='less -r'                          # raw control characters
# alias whence='type -a'                        # where, of a sort
alias grep='grep --color'                     # show differences in colour
alias egrep='egrep --color=auto'              # show differences in colour
alias fgrep='fgrep --color=auto'              # show differences in colour
#
# Some shortcuts for different directory listings
alias ls='ls -hF --color=tty'                 # classify files in colour
# alias dir='ls --color=auto --format=vertical'
# alias vdir='ls --color=auto --format=long'
alias ll='ls -lA'                              # long list
alias la='ls -A'                              # all but . and ..
# alias l='ls -CF'                              #

# NZ
alias so='source'
alias ..='cd ..'
alias ...='cd ../..'

##############################################################################
#
# Windows Apps
#
##############################################################################

######
# GVim
######
VIM="C:\Program Files (x86)\Vim"
winhome="C:\Users\nzga"
alias gvim='VIM=`cygpath -d "$VIM"` HOME=`cygpath -d "$winhome"` "`cygpath -u "$VIM"`/vim74/gvim.exe"'

######
# Gitk
######
#Doesn't work
#GITK="C:\Program Files (x86)\Git\bin\gitk"
#alias gitk='"$(cygpath -m -s "$GITK")"'
# call git gui from Git For Windows path with `ggui`
gg() {
    command "/cygdrive/c/Program Files (x86)/Git/bin/git" gui  2>/dev/null;
}
