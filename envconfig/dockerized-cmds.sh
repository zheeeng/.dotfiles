alias vue='docker run -it --rm -v "$PWD":/code ebiven/vue-cli vue'
alias stylus='docker run -it --rm -v "$PWD":/src zheeeng/stylus-cli stylus'
alias json-server='_() { local port; local args; port=3000; args=$@; while [[ $1 != "" ]]; do case $1 in -p | --port ) shift; port=$1; break;; *) shift;; esac; done; eval docker run -it --rm -p $port:$port -v $PWD:/data zheeeng/json-server '"\'"'json-server $args'"\'"'; }; _'
alias tsc='docker run -it --rm -v "$PWD":/workspace harmish/typescript tsc'
alias yarn='docker run -it --rm -v "$PWD":/workspace -w /workspace node:latest yarn' # make sure your node version is above 7.6
