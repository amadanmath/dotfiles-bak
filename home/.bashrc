export CLICOLOR=1
export LANG=en_US.UTF-8
export GOPATH="$HOME/prog/go"

# http://superuser.com/a/39995/39723
pathadd() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="${PATH:+"$PATH:"}$1"
    fi
}
pathadd "$HOME/.rvm/bin"
pathadd "$HOME/.bin"
pathadd "$HOME/local/bin"
pathadd "$GOPATH/bin"

if [ -s ~/.lastcwd ]; then
  TMPOLDPWD=`cat ~/.lastcwd`
  if [ -n "$TMPOLDPWD" ]; then
    rm -f ~/.lastcwd
    export OLDPWD="$TMPOLDPWD"
  fi
fi

if [ -s ~/.bash/aliases ]; then
  source ~/.bash/aliases
fi

if [ -s ~/.bash/prompt ]; then
  source ~/.bash/prompt
fi

if [ -s ~/.bash/os.`uname` ]; then
  source ~/.bash/os.`uname`
fi

if [ -s "$HOME/.rvm/scripts/rvm" ]; then
  source "$HOME/.rvm/scripts/rvm"
fi

export PAGER="less"
export LESS="-RS"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
