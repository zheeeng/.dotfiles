alias h='history'
alias his='h'
alias l='ls -lah'
alias la='ls -lAh'
alias ll='ls -lh'
alias ls='ls -G'
alias lsa='ls -lah'
alias cl='clear'
alias cll='clear && l'
alias cla='clear && la'
alias clll='clear && ll'
alias clls='clear && ls'
alias cllsa='clear && lsa'
alias rmdir='rm -rf'
alias cpdir='cp -rf'
alias mkcd='_(){ mkdir $1; cd $1; }; _'
alias webshare='python -c "import SimpleHTTPServer;SimpleHTTPServer.test()"'
alias mlre="pbpaste | refmt --parse ml --print re --interface false | pbcopy"
alias reml="pbpaste | refmt --parse re --print ml --interface false | pbcopy"

# greps
alias aligrep='alias | grep'
alias aliasgrep='aligrep'
alias hisgrep='history | grep'
alias psgrep='ps | grep'

# fp455
alias fp=' fp455'
