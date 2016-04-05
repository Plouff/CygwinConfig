# To the extent possible under law, the author(s) have dedicated all
# copyright and related and neighboring rights to this software to the
# public domain worldwide. This software is distributed without any warranty.
# You should have received a copy of the CC0 Public Domain Dedication along
# with this software.
# If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

# base-files version 4.2-3

# ~/.bashrc: executed by bash(1) for interactive shells.

# The latest version as installed by the Cygwin Setup program can
# always be found at /etc/defaults/etc/skel/.bashrc

# Modifying /etc/skel/.bashrc directly will prevent
# setup from updating it.

# The copy in your home directory (~/.bashrc) is yours, please
# feel free to customise it to create a shell
# environment to your liking.  If you feel a change
# would be benifitial to all, please feel free to send
# a patch to the cygwin mailing list.

# User dependent .bashrc file

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# Shell Options
#
# See man bash for more options...
#
# Don't wait for job termination notification
# set -o notify
#
# Don't use ^D to exit
set -o ignoreeof
#
# Use case-insensitive filename globbing
shopt -s nocaseglob
#
# Make bash append rather than overwrite the history on disk
shopt -s histappend
#
# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
# shopt -s cdspell

# Completion options
#
# These completion tuning parameters change the default behavior of bash_completion:
#
# Define to access remotely checked-out files over passwordless ssh for CVS
# COMP_CVS_REMOTE=1
#
# Define to avoid stripping description in --option=description of './configure --help'
# COMP_CONFIGURE_HINTS=1
#
# Define to avoid flattening internal contents of tar files
# COMP_TAR_INTERNAL_PATHS=1

##################################################################################
# Aliases
##################################################################################
# Uncomment to turn on programmable completion enhancements.
# Any completions you add in ~/.bash_completion are sourced last.
[[ -f /etc/bash_completion ]] && . /etc/bash_completion

# History Options
#
# Don't put duplicate lines in the history.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
#
# Ignore some controlling instructions
# HISTIGNORE is a colon-delimited list of patterns which should be excluded.
# The '&' is a special pattern which suppresses duplicate entries.
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit'
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls' # Ignore the ls command as well
#
# Whenever displaying the prompt, write the previous line to disk
# export PROMPT_COMMAND="history -a"

##################################################################################
# Umask
#
# /etc/profile sets 022, removing write perms to group + others.
# Set a more restrictive umask: i.e. no exec perms for others:
umask 027
# Paranoid: neither group nor others have any perms:
# umask 077

##################################################################################
# Aliases
##################################################################################
if [ -f "${HOME}/.bash_aliases" ]; then
  source "${HOME}/.bash_aliases"
fi

##################################################################################
# Functions
##################################################################################

if [ -f "${HOME}/.bash_functions" ]; then
  source "${HOME}/.bash_functions"
fi

# Aliased functions
alias cd=cd_func
alias g=win_gvim_wrapper

##################################################################################
# Misc options
##################################################################################
# Language
export LANG='en_GB.UTF-8'

##################################################################################
# Custom path
##################################################################################

# Converter projects
export zgoti='/cygdrive/c/Users/nzga/DEV/TI_CodeComposerStudio/CodeComposerWorkspaces'
#export zgov2='/cygdrive/c/Users/nzga/DEV/TI_CodeComposerStudio/CodeComposerWorkspaces/956_DCDC_Converter_V2_350_750/Git/099-1232DC333/1232SW001'
export zgov2='/cygdrive/c/Nassim/Sources/DCDCv2Git/1232SW001'
#export zgov2svn='/cygdrive/c/Users/nzga/DEV/TI_CodeComposerStudio/CodeComposerWorkspaces/956_DCDC_Converter_V2_350_750/SVN/trunk/1232SW001'
export zgov2svn='/cygdrive/c/Nassim/Sources/SVN'
export zgov1='/cygdrive/c/Users/nzga/DEV/TI_CodeComposerStudio/CodeComposerWorkspaces/952_Smart_DCDC_Converter/trunk'
export zgosymbio='/cygdrive/c/Users/nzga/DEV/TI_CodeComposerStudio/CodeComposerWorkspaces/465_SymbioFCell-1092SW001_REF/Trunk'

# Other
export zgocvi='/cygdrive/c/Users/nzga/DEV/CVI'

