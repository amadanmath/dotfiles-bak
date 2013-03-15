export CLICOLOR=1
export LANG=en_US.UTF-8

# http://superuser.com/a/39995/39723
pathadd() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="${PATH:+"$PATH:"}$1"
    fi
}
pathadd "~/bin"
pathadd "~/local/bin"
pathadd "~/.rvm/bin"

if [ -f ~/.lastcwd ]; then
  export OLDPWD=`cat ~/.lastcwd`
  rm ~/.lastcwd
fi

if [ -f ~/.bash/aliases ]; then
  source ~/.bash/aliases
fi

if [ -f ~/.bash/prompt ]; then
  source ~/.bash/prompt
fi

if [ -f ~/.bash/os.`uname` ]; then
  source ~/.bash/os.`uname`
fi

