# Source system default ---------------------------------------
if [ -f /etc/profile ]; then
  . /etc/profile
fi

# Basic setting -----------------------------------------------
OS_TYPE=`uname`
if [ -z "$OS_TYPE" ]; then
  OS_TYPE="unknown"
fi

# for Japanese and English ------------------------------------
alias ja='export LANG=ja_JP.UTF-8; export LANGUAGE=ja_JP.UTF-8; export LC_ALL=ja_JP.UTF-8'
alias en='export LANG=en_US.UTF-8; export LANGUAGE=en_US.UTF-8; export LC_ALL=en_US.UTF-8'

# is this interactive shell or not -------------------------------
echo $- | grep -q i && INTERACTIVE=1 || INTERACTIVE=0

# Source the Machine independent setting  ------------------------
if [ -f .bashrc.local ]; then
  source .bashrc.local
fi

if [ "$USER" = "root" ]; then
  PMARK="#"
else
  PMARK="$"
fi

HISTSIZE=100000
HISTFILESIZE=100000

if [ -n "$NICKNAME" ]; then
  PS1="[$NICKNAME]\w $PMARK "
else
  PS1="[\h]\w $PMARK "
fi

# shopt --------------------------------------------------------
shopt -s globstar

# disable bell -------------------------------------------------
if [ $INTERACTIVE -eq 1 ]; then
  bind 'set bell-style none'
fi

# blade --------------------------------------------------------
if [ -z "$BLADE_DIR" ]; then
  export BLADE_DIR=~/misc/blade
fi


# Editor --------------------------------------------------------
export EDITOR=vim
export SVN_EDITOR=$EDITOR

# distcc ---------------------------------------------------------
#export DISTCC_HOSTS='localhost'

# screen ---------------------------------------------------------
alias screen='screen -U'
alias screen-flow-offs='screen -X defflow off; screen -X flow off'
alias update-ssh-auth-sock="$BLADE_DIR/bin/update-ssh-auth-sock.py -v > ~/.ssh-auth-sock-env && . ~/.ssh-auth-sock-env"

# grep -----------------------------------------------------------
export GREP_COLORS='1;47;41'
alias grep='grep -E --color=auto'

# PATH -----------------------------------------------------------
export PATH=$EXTRA_PATH:~/bin:$BLADE_DIR/bin:~/.local/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin

DEVTOOLSET2_DIR=/opt/rh/devtoolset-2
DEVTOOLSET2_BIN_DIR=$DEVTOOLSET2_DIR/root/usr/bin
if [ -d $DEVTOOLSET2_BIN_DIR ]; then
  export PATH=$DEVTOOLSET2_BIN_DIR:$PATH
fi

# Scala ----------------------------------------------------------
if [ $OS_TYPE = "Darwin" ]; then
  export SCALA_HOME=/opt/scala
fi
if [ -n "$SCALA_HOME" ]; then
  export PATH=$PATH:$SCALA_HOME/bin
fi

# Gradle ----------------------------------------------------------
if [ -n "$GRADLE_HOME" ]; then
  export PATH=$PATH:$GRADLE_HOME/bin
fi

# CUDA ----------------------------------------------------------
# CUDA_DIR has to be set in another place (e.g. .bashrc.local)
if [ -n "$CUDA_DIR" ]; then
  export PATH=$CUDA_DIR/bin:$PATH
fi

# Pyenv ----------------------------------------------------------
export PYENV_ROOT=~/.pyenv
export PATH=$PYENV_ROOT/bin:$PATH

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

alias reset2='reset; stty sane; tput rs1; clear; echo -e "\033c"'

# ls -------------------------------------------------------------
if [ $OS_TYPE = "Linux" ]; then
  alias ls='ls -h'
  alias ll='ls -lhs'
  alias lla='ls -alhs'

  export LS_COLORS='no=97:fi=97:di=38;5;117:ln=38;5;146:pi=93:so=95:bd=93:cd=93:or=92:ex=38;5;112:su=93;44:sg=93;44:ow=38;5;253;48;5;23:*core=91'
  alias ls='ls --color=auto --show-control-chars'
fi
if [ $OS_TYPE = "Darwin" ]; then
  alias ls='ls -Gh'
  alias ll='ls -lGhs'
  alias lla='ls -aGlhs'
  export BLOCKSIZE=1048576
  export LSCOLORS=GxCxcxdxDxegedabagHfHf
fi

# MAKE -----------------------------------------------------------
if [ $OS_TYPE = "Linux" -a -z "$MAKEFLAGS" ]; then
  NUM_CPU=`cat /proc/cpuinfo | grep ^processor | wc -l`
  export MAKEFLAGS="-j${NUM_CPU}"
fi

# GNU screen: title ----------------------------------------------
if [ -z "$SCREEN_HOST" ]; then
  export SCREEN_HOST=`echo $HOSTNAME | sed "s,\..*$,,"`:
fi

if [ "$TERM" = "screen" -o "$TERM" = "screen-256color" ]; then
  USE_SCREEN=1
else
  USE_SCREEN=0
fi

function escape_non_ascii() {
  LANG=C sed s/[^[:print:]]\\+/?/g
}

function set_screen_title () {
  cmd=`history 1 | sed s/\ *[0-9]*\ *// | escape_non_ascii`
  echo -en "\033k${SCREEN_HOST}${cmd}\033\\"
}

if [ $USE_SCREEN -eq 1 ]; then
  trap "set_screen_title" DEBUG
fi

function printdir() {
  dirname=$(basename ${PWD} | escape_non_ascii)
  echo -en "\033k${SCREEN_HOST}[$dirname]\033\\"
}

if [ $USE_SCREEN -eq 1 ]; then
  PROMPT_COMMAND='printdir'
fi
