# Basic setting -----------------------------------------------
OS_TYPE=`uname`
if [ -z $OS_TYPE ]; then
  OS_TYPE="unknown"
fi

# for Japanese and English ------------------------------------
alias utf='export LANG=ja_JP.UTF-8; export LANGUAGE=ja_JP.UTF-8; export LC_ALL=ja_JP.UTF-8'
alias en='export LANG=en_US.UTF-8; export LANGUAGE=en_US.UTF-8; export LC_ALL=en_US.UTF-8'

if [ x$TERM = xxterm ]; then
  en
fi

# Source the Machine independent setting  ------------------------
if [ -f .bashrc.local ]; then
  source .bashrc.local
fi

if [ x$USER = x"root" ]; then
  PMARK="#"
else
  PMARK="$"
fi

HISTSIZE=100000
HISTFILESIZE=100000

if [ x$NICKNAME != x ]; then
  PS1="[$NICKNAME]\w $PMARK "
else
  PS1="[\h]\w $PMARK "
fi

# Subversion ----------------------------------------------------
export SVN_EDITOR=vim

# distcc ---------------------------------------------------------
#export DISTCC_HOSTS='localhost'

# screen ---------------------------------------------------------
alias screen='screen -U'
alias screen-flow-offs='screen -X defflow off; screen -X flow off'
alias screen-ssh-auth-sock-update='~/misc/priv-misc/bin/screen-ssh-auth-sock-update.py > ~/.screen-ssh-auth && . ~/.screen-ssh-auth'

# grep -----------------------------------------------------------
export GREP_COLOR='1;37;41'
alias grep='grep -E --color=auto'

# PATH -----------------------------------------------------------
export PATH=~/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:~/android-sdk-linux_86/tools

DEVTOOLSET2_DIR=/opt/rh/devtoolset-2
DEVTOOLSET2_BIN_DIR=$DEVTOOLSET2_DIR/root/usr/bin
if [ -d $DEVTOOLSET2_BIN_DIR ]; then
  export PATH=$DEVTOOLSET2_BIN_DIR:$PATH
fi

# Scala ----------------------------------------------------------
if [ $OS_TYPE = "Darwin" ]; then
  export SCALA_HOME=/opt/scala
fi
if [ -e $SCALA_HOME ]; then
  export PATH=$PATH:$SCALA_HOME/bin
fi

# CUDA ----------------------------------------------------------
# CUDA_DIR has to be set in another place (e.g. .bashrc.local)
if [ -e $CUDA_DIR ]; then
  export PATH=$CUDA_DIR/bin:$PATH
fi

# Aliases --------------------------------------------------------
alias vi=vim

alias cp='cp -iv'
alias rm='rm -iv'
alias mv='mv -iv'
if [ $OS_TYPE = "Linux" ]; then
  alias od='od -tx1z -Ax -v'
fi
if [ $OS_TYPE = "Darwin" ]; then
  alias od='od -tx1 -Ax'
fi


alias su='su -'
alias less='less -R'
alias gdb='gdb -q'

# ls -------------------------------------------------------------
if [ $OS_TYPE = "Linux" ]; then
  alias ls='ls -h'
  alias ll='ls -lhs'
  alias lla='ls -alhs'

  export LS_COLORS='no=01;37;49:fi=00;39;49:di=01;36;49:ln=01;32;49:pi=01;33;49:so=01;35;49:bd=01;33;49:cd=01;33;49:or=01;32;49:ex=01;33;49:su=01;33;44:sg=01;33;44:*core=01;31'
  alias ls='ls --color=auto --show-control-chars'
fi
if [ $OS_TYPE = "Darwin" ]; then
  alias ls='ls -Gh'
  alias ll='ls -lGhs'
  alias lla='ls -aGlhs'
  export BLOCKSIZE=1048576
  export LSCOLORS=gxcxcxdxDxegedabagacad
fi

# GNU screen: title ----------------------------------------------
if [ x$NICKNAME != x ]; then
   export SCREEN_HOST=$NICKNAME:
else
   export SCREEN_HOST=`echo $HOSTNAME | sed "s,\..*$,,"`:
fi

if [ x$TERM = xscreen -o x$TERM = xscreen-256color ]; then
  USE_SCREEN=1
else
  USE_SCREEN=0
fi

function title_screen () {
  cmd=`history 1 | sed s/\ *[0-9]*\ *//`
  echo -en "\033k$SCREEN_HOST$cmd\033\\"
}

if [ $USE_SCREEN -eq 1 ]; then
  trap "title_screen" DEBUG
fi

function printdir() {
  echo -en "\033k[$SCREEN_HOST$(pwd | awk '{ print $(NF) }' FS='/')]\033\\"
}

if [ $USE_SCREEN -eq 1 ]; then
  PROMPT_COMMAND='printdir'
fi
