alias vue='docker run -it --rm -v "$PWD":/code ebiven/vue-cli vue'
alias stylus='docker run -it --rm -v "$PWD":/src zheeeng/stylus-cli stylus'
alias json-server='_() { local port; local paras; port=3000; paras=$@; echo $@; echo $paras; while [[ $1 != "" ]]; do echo $1; case $1 in -p | --port ) shift; port=$1; break;; *) shift;; esac; done; eval "docker run -it --rm -p $port:$port -v $PWD:/data zheeeng/json-server json-server $paras"; }; _'
