# Basic setting -----------------------------------------------
OS_TYPE=`uname`
if [ -z $OS_TYPE ]; then
  OS_TYPE="unknown"
fi

# for Japanese and English ------------------------------------
alias utf='export LANG=ja_JP.UTF-8; export LANGUAGE=ja_JP.UTF-8; export LC_ALL=ja_JP.UTF-8'
alias en='export LANG=en.UTF-8; export LANGUAGE=en.UTF-8; export LC_ALL=C'

if [ x$TERM = xxterm ]; then
  en
fi

# Source the Machine independent setting  ------------------------
if [ -f /etc/def.bashrc ]; then
  source /etc/def.bashrc
fi

if [ -f .hostname ]; then
  HOST=`cat .hostname`
fi

if [ x$USER = x"root" ]; then
  PMARK="#"
else
  PMARK="$"
fi

HISTSIZE=100000
HISTFILESIZE=100000

if [ x$HOST != x ]; then
  PS1="[$HOST]\w $PMARK "
else
  PS1="[\h]\w $PMARK "
fi

# Subversion ----------------------------------------------------
export SVN_EDITOR=vim

# ROOT -----------------------------------------------------------
#if [ x$HOSTNAME = xmi ]; then
#  export ROOTSYS=/cern/root
#  alias  root='root -l'
#  #export SAMBADIR=/usr/local/samba
#fi

# teTeX ----------------------------------------------------------
#if [ x$HOSTNAME = xmi ]; then
#  export TETEX_PATH=/usr/local/teTeX
#  #export TEXMF=$TETEX_PATH/share/texmf
#fi

# Python ---------------------------------------------------------
#if [ x$HOSTNAME = xmi ]; then
#  #export PYTHONPATH=/usr/local/lib/python2.5/site-packages:$ROOTSYS/lib:~/michi.work/tools/slib
#  export PYTHONPATH=/usr/local/lib/python2.4/site-packages:$ROOTSYS/lib:~/michi.work/tools/slib
#  export PYTHONSTARTUP=~/.pyrc
#  #export WINEPREFIX=/usr/local/winedrive
#fi

# rsync ----------------------------------------------------------
#alias rsync='rsync -avzu'

# distcc ---------------------------------------------------------
#export DISTCC_HOSTS='localhost'

# screen ---------------------------------------------------------
alias screen='screen -U'

# grep -----------------------------------------------------------
#export GREP_COLOR='1;33'
export GREP_COLOR='1;37;41'
alias grep='grep -E --color=auto'

# xdvi ----------------------------------------------------------
#export TEXMF=/usr/local/teTeX/texmf
#export XDVIINPUTS='.;$TEXMF/{xdvi,dvips}//'

# Open Office ----------------------------------------------------
#export OOO_FORCE_DESKTOP=none

# PATH -----------------------------------------------------------
export PATH=~/bin:/usr/local/bin:/usr/local/X11R7/bin:/usr/bin:/bin:./:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/cross-i686/bin:~/android-sdk-linux_86/tools

# /lib in LD_LIBRARY_PATH may happens errors of package updates in 64bit Distros.
#export LD_LIBRARY_PATH=/usr/local/lib:/usr/lib:/lib

# Cygwin ---------------------------------------------------------
if [ $OS_TYPE = "Cygwin" ]; then
    export DBUS_SESSION_BUS_ADDRESS="tcp:host=localhost,port=30100"
    export PATH=$PATH:/cygdrive/c/Windows/System32
fi

# Scala ----------------------------------------------------------
if [ $OS_TYPE = "Darwin" ]; then
  export SCALA_HOME=/opt/scala
  export PATH=$PATH:$SCALA_HOME/bin
fi

# Path for emdevkitwin32 -----------------------------------------
EMDEVKITWINRC=/cygdrive/c/emdevkitwin32/emdevkitwinrc
if [ -f $EMDEVKITWINRC ]; then
  . $EMDEVKITWINRC
  export PATH=$EMDEVKITWIN32_BINS:$PATH
  export PKG_CONFIG_PATH=$EMDEVKITWIN32_PKG_CONFIG_PATH
fi

export MINGW32_ROOT=/usr/i686-pc-mingw32
export MINGW32_SYSROOT=$MINGW32_ROOT/sys-root/mingw
if [ -d $MINGW32_ROOT ]; then
  export PATH=$PATH:$MINGW32_ROOT/bin:$MINGW32_SYSROOT/bin
fi

# Aliases --------------------------------------------------------
alias ls='ls -Gh'
alias ll='ls -lGhs'
alias lla='ls -alGhs'
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
  export LS_COLORS='no=01;37;49:fi=00;39;49:di=01;36;49:ln=01;32;49:pi=01;33;49:so=01;35;49:bd=01;33;49:cd=01;33;49:or=01;32;49:ex=01;33;49:su=01;33;44:sg=01;33;44:*core=01;31'
  if [ `ls --version | head -n1 | awk '{ if( $NF > 5.9 ) print "1"; else print "0"; }'` -ne 0 ]; then
    export LS_COLORS=$LS_COLORS':ow=01;36;44:tw=01;36;44'
  fi
  alias ls='ls --color=auto --show-control-chars'
fi
if [ $OS_TYPE = "Darwin" ]; then
  export LSCOLORS=gxcxcxdxDxegedabagacad
fi

# GNU screen: title ----------------------------------------------
if [ $HOSTNAME != michi ]; then
   export SCREEN_HOST=`echo $HOSTNAME | sed "s,\..*$,,"`:
fi

function title_screen () {
  cmd=`history 1 | sed s/\ *[0-9]*\ *//`
  echo -en "\033k$SCREEN_HOST$cmd\033\\"
}

if [ x$TERM = xscreen ]; then
  trap "title_screen" DEBUG
fi

# function printdir()
function printdir() {
  echo -en "\033k[$SCREEN_HOST$(pwd | awk '{ print $(NF) }' FS='/')]\033\\"
  #echo -en "\033k[$SCREEN_HOST$(pwd | awk '{ print $(NF) }' FS='/')]\033\134"
}

if [ x$TERM = xscreen ]; then
  PROMPT_COMMAND='printdir'
fi
