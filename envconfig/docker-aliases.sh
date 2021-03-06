_DOCKER_ALIAS_FILE=$0

if [[ ! $_DOCKER_ALIAS_PREFIX =~ ^[[:alnum:]_]{1,}$ ]]; then
    _DOCKER_ALIAS_PREFIX=dk
fi

dkalias() {
    local usage='
    \rOptions:
        \r -a \t\t Alias frequently-used docker commands to shorter ones
        \r -h \t\t Print usage
        \r -m [hint] \t List fuzzy matched aliases by hint, the alias descriptions employ the initial aliases prefix "dk"
        \r -p [prefix] \t Reset the docker aliases "prefix", the default value is "dk". \e[31m Warning: Before you reset the aliases prefix, make sure it will not cause aliases overriding on exist commands. e.g. `dkalias -p w` add an alias "wc" which is a built-in command and now refers to execute "docker commit", it may bring side effects on ".rc" scripts and other stuffs. \e[0m
        \r -u \t\t Unalias setted aliases\n'

    local success_message='\\rYou specified the new alias prefix \""${_DOCKER_ALIAS_PREFIX}\"".\\n\\r\\e\[32mSuccessfully set aliases.\\e\[0m\\n\\rNow you can just type \""${_DOCKER_ALIAS_PREFIX}\"" instead of \""docker\"". To get the details of aliases, type \""dkalias\"" or \""dkalias -m [hint]\""'

    if [[ $# -eq 0 ]]; then
        dkalias -m alias
        return 0
    fi

    local OPTIND

    while getopts ahm:p:u OPT; do
        case $OPT in
            a)
                source $_DOCKER_ALIAS_FILE
                eval echo $success_message
                return 0
                ;;
            h)
                echo $usage
                return 0
                ;;
            m)
                patt=$(echo $OPTARG | sed 's/./&\.\\{0,6\\}/g')
                sed -n "/^# g[^-]* -\{1,2\} .*${patt}/,/^$/p" $_DOCKER_ALIAS_FILE \
                 | sed -e "s/\${_DOCKER_ALIAS_PREFIX}\('\{0,1\}\)/\1${_DOCKER_ALIAS_PREFIX}/g" -e '$d'
                return 0
                ;;
            p)
                local TEMP_DOCKER_ALIAS_PREFIX
                TEMP_DOCKER_ALIAS_PREFIX=$OPTARG
                dkalias -u
                _DOCKER_ALIAS_PREFIX=$TEMP_DOCKER_ALIAS_PREFIX
                dkalias -a
                return 0
                ;;
            u)
                local to_unalias
                local total_count
                local unalias_fail_msg
                local total_err_count

                echo "Current alias prefix is \"${_DOCKER_ALIAS_PREFIX}\". Unalias them... wait"

                # Gather aliases which to unalias
                to_unalias=$(sed -n "s/^alias \${_DOCKER_ALIAS_PREFIX}\([[:alnum:]\!~]*\)='.*'$/${_DOCKER_ALIAS_PREFIX}\1/p" $_DOCKER_ALIAS_FILE | tr '\n' ' ')

                # Count the number of aliases which to be unaliased
                total_count=$(echo $to_unalias | wc -w | tr -d ' ')

                # Test unalias execution result and count the number of failure entries.
                unalias_fail_msg=$(eval unalias $to_unalias 2>&1 > /dev/null | sed -n "s/.*unalias:.* no such hash table element: \([[:alnum:]\!~]*\)$/\1/p" | tr '\n' ' ')
                total_err_count=$(echo $unalias_fail_msg | wc -w | tr -d ' ' )

                # Evaluation unalias
                eval unalias $to_unalias 2> /dev/null

                # Print necessary messages
                if [[ $total_err_count -gt 0 ]]; then
                    echo '\e[31mYou may have already unsetted these aliases:'
                    echo $unalias_fail_msg '(total: ' $total_err_count ')\e[0m'
                fi
                if [[ $total_count -ne $total_err_count ]]; then
                    echo '\e[32mSuccessfully unsetted' $((total_count - total_err_count)) 'aliases.\e[0m'
                fi
                return 0
                ;;
            \?)
                echo $usage
                return 1
                ;;
        esac
    done
}

# docker aliases outline(with initial prefix "dk") - docker aliases <-> commands
# '*' means sub command alias
#|----------------------------------------
#| dkalias - get docker aliases
#| dk - docker
#| dka - docker attach
#| dkb - docker build
#| dkc - docker commit
#| dkcp -- docker cp
#| dkcpt -- docker checkpoint *
#| dkcr -- docker create
#| dkd - docker deploy
#| dkdf -- docker diff
#| dke, dkep - docker export
#| dkev -- docker event
#| dkexe, dkexec -- docker exec
#| dkh - docker history
#| dki, dkip - docker import
#| dkimgs -- docker images
#| dkinfo -- docker info
#| dkins -- docker inspect
#| dkk - docker kill
#| dkl, dkld - docker load
#| dkli, dklogin -- docker login
#| dklo, dklogout -- docker logout
#| dklg, dklog -- docker logs
#| dkp - docker push
#| dkpause, dkunpause -- docker pause or docker unpause
#| dkport -- docker port
#| dkps -- docker ps
#| dkpl -- docker pull
#| dkr - docker run
#| dkrm -- docker rm
#| dkrmi -- docker rmi
#| dkrn -- docker rename
#| dkrs -- docker restart
#| dks - docker start
#| dks~, dkstop - docker stop
#| dksave -- docker save
#| dksear, dksearch -- docker search
#| dkst -- docker stats
#| dkt - docker tag
#| dktop -- docker top
#| dku - docker update
#| dkv - docker version
#| dkvol - docker volume *
#| dkw - docker wait

# dk - docker
alias ${_DOCKER_ALIAS_PREFIX}='docker'
alias ${_DOCKER_ALIAS_PREFIX}h='docker --help'

#| dka - docker attach
alias ${_DOCKER_ALIAS_PREFIX}a='docker attach'
alias ${_DOCKER_ALIAS_PREFIX}ah='docker attach --help'

# dkb - docker build
alias ${_DOCKER_ALIAS_PREFIX}b='docker build'
alias ${_DOCKER_ALIAS_PREFIX}bh='docker build --help'

#| dkc - docker commit
alias ${_DOCKER_ALIAS_PREFIX}c='docker commit'
alias ${_DOCKER_ALIAS_PREFIX}ch='docker commit --help'

#| dkcp -- docker cp
alias ${_DOCKER_ALIAS_PREFIX}cp='docker cp'
alias ${_DOCKER_ALIAS_PREFIX}cph='docker cp --help'

#| dkcpt -- docker checkpoint *
alias ${_DOCKER_ALIAS_PREFIX}cpt='docker checkpoint'
alias ${_DOCKER_ALIAS_PREFIX}cptc='docker checkpoint create'
alias ${_DOCKER_ALIAS_PREFIX}cptl='docker checkpoint ls'
alias ${_DOCKER_ALIAS_PREFIX}cptrm='docker checkpoint rm'
alias ${_DOCKER_ALIAS_PREFIX}cpth='docker checkpoint --help'

#| dkcr -- docker create
alias ${_DOCKER_ALIAS_PREFIX}cr='docker create'
alias ${_DOCKER_ALIAS_PREFIX}crh='docker create --help'

#| dkd - docker deploy
alias ${_DOCKER_ALIAS_PREFIX}d='docker deploy'
alias ${_DOCKER_ALIAS_PREFIX}dh='docker deploy --help'

#| dkdf -- docker diff
alias ${_DOCKER_ALIAS_PREFIX}df='docker diff'
alias ${_DOCKER_ALIAS_PREFIX}dfh='docker diff --help'

#| dke, dkep - docker export
alias ${_DOCKER_ALIAS_PREFIX}de='docker export'
alias ${_DOCKER_ALIAS_PREFIX}deh='docker export --help'
alias ${_DOCKER_ALIAS_PREFIX}dep=${_DOCKER_ALIAS_PREFIX}'de'
alias ${_DOCKER_ALIAS_PREFIX}deph=${_DOCKER_ALIAS_PREFIX}'de --help'

#| dkev -- docker event
alias ${_DOCKER_ALIAS_PREFIX}ev='docker event'
alias ${_DOCKER_ALIAS_PREFIX}evh='docker event --help'

#| dkexe, dkexec -- docker exec
alias ${_DOCKER_ALIAS_PREFIX}exe='docker exec'
alias ${_DOCKER_ALIAS_PREFIX}exeh='docker exec --help'
alias ${_DOCKER_ALIAS_PREFIX}exec=${_DOCKER_ALIAS_PREFIX}'exe'
alias ${_DOCKER_ALIAS_PREFIX}exech=${_DOCKER_ALIAS_PREFIX}'exe --help'

#| dkh - docker history
alias ${_DOCKER_ALIAS_PREFIX}h='docker history'
alias ${_DOCKER_ALIAS_PREFIX}hh='docker history --help'

#| dki, dkip - docker import
alias ${_DOCKER_ALIAS_PREFIX}i='docker import'
alias ${_DOCKER_ALIAS_PREFIX}ih='docker import --help'
alias ${_DOCKER_ALIAS_PREFIX}ip=${_DOCKER_ALIAS_PREFIX}'i'
alias ${_DOCKER_ALIAS_PREFIX}iph=${_DOCKER_ALIAS_PREFIX}'i --help'

#| dkimgs -- docker images
alias ${_DOCKER_ALIAS_PREFIX}imgs='docker images'
alias ${_DOCKER_ALIAS_PREFIX}imgsh='docker images --help'

#| dkinfo -- docker info
alias ${_DOCKER_ALIAS_PREFIX}info='docker info'
alias ${_DOCKER_ALIAS_PREFIX}infoh='docker info --help'

#| dkins -- docker inspect
alias ${_DOCKER_ALIAS_PREFIX}ins='docker inspect'
alias ${_DOCKER_ALIAS_PREFIX}insh='docker inspect --help'

#| dkk - docker kill
alias ${_DOCKER_ALIAS_PREFIX}k='docker kill'
alias ${_DOCKER_ALIAS_PREFIX}kh='docker kill --help'

#| dkl, dkld - docker load
alias ${_DOCKER_ALIAS_PREFIX}l='docker load'
alias ${_DOCKER_ALIAS_PREFIX}lh='docker load --help'
alias ${_DOCKER_ALIAS_PREFIX}ld=${_DOCKER_ALIAS_PREFIX}'l'
alias ${_DOCKER_ALIAS_PREFIX}ldh=${_DOCKER_ALIAS_PREFIX}'l --help'

#| dkli, dklogin -- docker login
alias ${_DOCKER_ALIAS_PREFIX}li='docker login'
alias ${_DOCKER_ALIAS_PREFIX}lih='docker login --help'
alias ${_DOCKER_ALIAS_PREFIX}login=${_DOCKER_ALIAS_PREFIX}'li'
alias ${_DOCKER_ALIAS_PREFIX}loginh=${_DOCKER_ALIAS_PREFIX}'li --help'

#| dklo, dklogout -- docker logout
alias ${_DOCKER_ALIAS_PREFIX}lo='docker logout'
alias ${_DOCKER_ALIAS_PREFIX}loh='docker logout --help'
alias ${_DOCKER_ALIAS_PREFIX}logout=${_DOCKER_ALIAS_PREFIX}'lo'
alias ${_DOCKER_ALIAS_PREFIX}logouth=${_DOCKER_ALIAS_PREFIX}'lo --help'

#| dklg, dklog -- docker logs
alias ${_DOCKER_ALIAS_PREFIX}lg='docker logs'
alias ${_DOCKER_ALIAS_PREFIX}lgh='docker logs --help'
alias ${_DOCKER_ALIAS_PREFIX}log=${_DOCKER_ALIAS_PREFIX}'lg'
alias ${_DOCKER_ALIAS_PREFIX}logh=${_DOCKER_ALIAS_PREFIX}'lg --help'

#| dkp - docker push
alias ${_DOCKER_ALIAS_PREFIX}p='docker push'
alias ${_DOCKER_ALIAS_PREFIX}ph='docker push --help'

#| dkpause, dkunpause -- docker pause or docker unpause
alias ${_DOCKER_ALIAS_PREFIX}pause='docker pause'
alias ${_DOCKER_ALIAS_PREFIX}pauseh='docker pause --help'
alias ${_DOCKER_ALIAS_PREFIX}unpause='docker unpause'
alias ${_DOCKER_ALIAS_PREFIX}unpauseh='docker unpause --help'

#| dkport -- docker port
alias ${_DOCKER_ALIAS_PREFIX}port='docker port'
alias ${_DOCKER_ALIAS_PREFIX}porth='docker port --help'

#| dkps -- docker ps
alias ${_DOCKER_ALIAS_PREFIX}ps='docker ps'
alias ${_DOCKER_ALIAS_PREFIX}psa='docker ps -a'
alias ${_DOCKER_ALIAS_PREFIX}psf='docker ps -f'
alias ${_DOCKER_ALIAS_PREFIX}psfmt='docker ps --format'
alias ${_DOCKER_ALIAS_PREFIX}psl='docker ps -l' # Show the latest created container (includes all states)
alias ${_DOCKER_ALIAS_PREFIX}psn='docker ps -n' # Show n last created containers (includes all states) (default -1)
alias ${_DOCKER_ALIAS_PREFIX}psh='docker ps --help'

#| dkpl -- docker pull
alias ${_DOCKER_ALIAS_PREFIX}pl='docker pull'
alias ${_DOCKER_ALIAS_PREFIX}plh='docker pull --help'

#| dkr - docker run
alias ${_DOCKER_ALIAS_PREFIX}r='docker run'
alias ${_DOCKER_ALIAS_PREFIX}rh='docker run --help'

#| dkrm -- docker rm
alias ${_DOCKER_ALIAS_PREFIX}rm='docker rm'
alias ${_DOCKER_ALIAS_PREFIX}rmh='docker rm --help'

#| dkrmi -- docker rmi
alias ${_DOCKER_ALIAS_PREFIX}rmi='docker rmi'
alias ${_DOCKER_ALIAS_PREFIX}rmih='docker rmi --help'

#| dkrn -- docker rename
alias ${_DOCKER_ALIAS_PREFIX}rn='docker rename'
alias ${_DOCKER_ALIAS_PREFIX}rnh='docker rename --help'

#| dkrs -- docker restart
alias ${_DOCKER_ALIAS_PREFIX}rs='docker restart'
alias ${_DOCKER_ALIAS_PREFIX}rsh='docker restart --help'

#| dks - docker start
alias ${_DOCKER_ALIAS_PREFIX}s='docker start'
alias ${_DOCKER_ALIAS_PREFIX}sh='docker start --help'

#| dks~, dkstop - docker stop
alias ${_DOCKER_ALIAS_PREFIX}ss='docker stop'
alias ${_DOCKER_ALIAS_PREFIX}stop=${_DOCKER_ALIAS_PREFIX}'ks~'
alias ${_DOCKER_ALIAS_PREFIX}stoph=${_DOCKER_ALIAS_PREFIX}'ks~ --help'

#| dksave -- docker save
alias ${_DOCKER_ALIAS_PREFIX}save='docker save'
alias ${_DOCKER_ALIAS_PREFIX}saveh='docker save --help'

#| dksear, dksearch -- docker search
alias ${_DOCKER_ALIAS_PREFIX}sear='docker search'
alias ${_DOCKER_ALIAS_PREFIX}searh='docker search --help'
alias ${_DOCKER_ALIAS_PREFIX}search=${_DOCKER_ALIAS_PREFIX}'sear'
alias ${_DOCKER_ALIAS_PREFIX}searchh=${_DOCKER_ALIAS_PREFIX}'sear --help'

#| dkst -- docker stats
alias ${_DOCKER_ALIAS_PREFIX}st='docker stats'
alias ${_DOCKER_ALIAS_PREFIX}sth='docker stats --help'

#| dkt - docker tag
alias ${_DOCKER_ALIAS_PREFIX}t='docker tag'
alias ${_DOCKER_ALIAS_PREFIX}th='docker tag --help'

#| dktop -- docker top
alias ${_DOCKER_ALIAS_PREFIX}top='docker top'
alias ${_DOCKER_ALIAS_PREFIX}toph='docker top --help'

#| dku - docker update
alias ${_DOCKER_ALIAS_PREFIX}u='docker update'
alias ${_DOCKER_ALIAS_PREFIX}uh='docker update --help'

#| dkv - docker version
alias ${_DOCKER_ALIAS_PREFIX}v='docker version'
alias ${_DOCKER_ALIAS_PREFIX}vh='docker version --help'

#| dkvol -- docker volume
alias ${_DOCKER_ALIAS_PREFIX}vol='docker volume'
alias ${_DOCKER_ALIAS_PREFIX}volc='docker volume create'
alias ${_DOCKER_ALIAS_PREFIX}volins='docker volume inspect'
alias ${_DOCKER_ALIAS_PREFIX}volinsf='docker volume inspect --format'
alias ${_DOCKER_ALIAS_PREFIX}voll='docker volume ls'
alias ${_DOCKER_ALIAS_PREFIX}vollf='docker volume ls -f'
alias ${_DOCKER_ALIAS_PREFIX}vollfmt='docker volume ls --format'
alias ${_DOCKER_ALIAS_PREFIX}volprune='docker volume prune'
alias ${_DOCKER_ALIAS_PREFIX}volrm='docker volume rm'
alias ${_DOCKER_ALIAS_PREFIX}volh='docker volume --help'

#| dkw - docker wait
alias ${_DOCKER_ALIAS_PREFIX}w='docker wait'
alias ${_DOCKER_ALIAS_PREFIX}wh='docker wait --help'
