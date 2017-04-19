# galias - get git aliases
_GIT_ALIAS_FILE=$0

if [[ ! $_GIT_ALIAS_PREFIX =~ ^[[:alnum:]_]{1,}$ ]]; then
    _GIT_ALIAS_PREFIX=g
fi

galias() {
    usage='
    \rOptions:
        \r -a \t\t Alias frequently-used git commands to shorter ones
        \r -h \t\t Print usage
        \r -m [hint] \t List fuzzy matched aliases by hint
        \r -p [prefix] \t Redefine the git aliases "prefix", the default value is "g"
        \r -u \t\t Unalias setted aliases\n'

    success_message='\\rThe git alias prefix is \""$_GIT_ALIAS_PREFIX\"", you can type \""$_GIT_ALIAS_PREFIX\"" instead of \""git\""'

    if [[ $# -eq 0 ]]; then
        sed -n "/^#\ g.*-\{1,2\}.*/,/^$/p" $_GIT_ALIAS_FILE | sed "s/^alias\ //g"
        return 0
    fi

    local OPTIND

    while getopts ahm:p:u OPT; do
        case $OPT in
            a)
                . $_GIT_ALIAS_FILE
                eval echo $success_message
                return 0
                ;;
            h)
                echo $usage
                return 0
                ;;
            m)
                string=$(echo $OPTARG | sed 's/./&\.\\{0,6\\}/g')
                sed -n "/^#\ g.*-\{1,2\}.*$string/,/^$/p" $_GIT_ALIAS_FILE | sed "s/^alias\ //g"
                return 0
                ;;
            p)
                _GIT_ALIAS_PREFIX=$OPTARG
                . $_GIT_ALIAS_FILE
                eval echo $success_message
                return 0
                ;;
            u)
                unalias $(sed -n "s/^#alias\ \(.*\)=\'.*\'$/\1/p" $_GIT_ALIAS_FILE)
                return 0
                ;;
            \?)
                echo $usage
                return 1
                ;;
        esac
    done
}

# git aliases outline - aliases <-> commands
#|----------------------------------------
#| galias - get git aliases
#| g - git
#| ga - git add
#| gac -- git add && commit
#| gar -- git archive
#| gb - git branch
#| gbl -- git blame
#| gbs -- git bisect
#| gc - git commit (end with '!' means --amend)
#| gcf -- git config
#| gcf~ -- git config --local
#| gcf! -- git config --global
#| gcl -- git clone
#| gclean! -- git clean
#| gco -- git checkout
#| gco~ -- git checkout -m, checkout with three-way merge
#| gco! -- git checkout -f
#| gcp -- git cherry-pick
#| gcount -- git count-objects
#| gd - git diff
#| gd! - git diff --cached
#| gdt -- git diff-tree
#| gde -- git describe
#| gf - git fetch
#| gi - git init
#| gignore, gignored, gignore~, gunignore - git ignore or unignore files
#| glg, glog - git log
#| glt - git 'log-tree'
#| glast - git 'last-log'
#| glf -- git ls-files, glf~ -- list untracked files or folders under current dir
#| gll, gls  -- git ls-tree, list tracked files with properties or tracked files in columns
#| gm - git merge
#| gmb, ganc -- git merge-base, get common ancestor commit
#| gmv -- git mv
#| gp - git push, gpp - git push all branches and their tags
#| gp! - git push --force
#| gpl -- git pull
#| gr - git remote
#| grb -- git rebase
#| grm -- git rm, grm~ -- untrack file[s]
#| grs -- git reset --mixed
#| grs~ -- git reset
#| grs! -- git reset --hard
#| grt -- git root
#| grv -- git revert
#| gs - git status
#| gshow, gcat -- git show/cat file content
#| gsl -- git shortlog
#| gsm -- git submodule
#| gsta -- git stash
#| gt - git tag && verify-tag
#| gwip - git wip(Work in Progress)
#| gwipe -- git wipe current work and leave a wipe savepoint

# g - git
alias ${_GIT_ALIAS_PREFIX}='git'

# ga - git add
alias ${_GIT_ALIAS_PREFIX}a='git add'
alias ${_GIT_ALIAS_PREFIX}a!='git add --force'
alias ${_GIT_ALIAS_PREFIX}aa='git add --all'
alias ${_GIT_ALIAS_PREFIX}ap='git add --patch'
alias ${_GIT_ALIAS_PREFIX}apa='gap'
alias ${_GIT_ALIAS_PREFIX}ai='git add --interactive'
alias ${_GIT_ALIAS_PREFIX}au='git add --update'
alias ${_GIT_ALIAS_PREFIX}aup='git add --update -p'
# gac -- git add && commit
alias ${_GIT_ALIAS_PREFIX}ac='git add -A . && git commit'
alias ${_GIT_ALIAS_PREFIX}ac!='git add -A . && git commit --amend'
alias ${_GIT_ALIAS_PREFIX}acm='git add -A . && git commit -m'
alias ${_GIT_ALIAS_PREFIX}acm!='git add -A . && git commit --amend -m'
alias ${_GIT_ALIAS_PREFIX}acmsg='gacm'
alias ${_GIT_ALIAS_PREFIX}acmsg!='gacmsg'

# gar -- git archive
alias ${_GIT_ALIAS_PREFIX}ar='git archive'
alias ${_GIT_ALIAS_PREFIX}argz='_() { ish=${1-HEAD}; if [ -n "`git rev-parse --verify $ish`" ]; then ver=`(git describe $ish || git describe --tags $ish) 2> /dev/null`; if [ -n  "$ver" ]; then if [ -n "$2" ]; then file=`echo $2 | sed "s/\(.*\)\.tar.gz/\1/;s/.*/&.tar.gz/"`; else file=`basename \`git rev-parse --show-toplevel\``"-$ver".tar.gz; fi; if [ ! -f "$file" ]; then git archive "$ish" --format=tar.gz --prefix="$ish/" -o "$file"; else echo "File \"$file\" already exists. Use \"gstac!\" force archiving. "; fi; else echo "No tags can describe this commit. "; fi; fi; }; _'
alias ${_GIT_ALIAS_PREFIX}artar='_() { ish=${1-HEAD}; if [ -n "`git rev-parse --verify $ish`" ]; then ver=`(git describe $ish || git describe --tags $ish) 2> /dev/null`; if [ -n  "$ver" ]; then if [ -n "$2" ]; then file=`echo $2 | sed "s/\(.*\)\.tar/\1/;s/.*/&.tar/"`; else file=`basename \`git rev-parse --show-toplevel\``"-$ver".tar; fi; if [ ! -f "$file" ]; then git archive "$ish" --format=tar --prefix="$ish/" -o "$file"; else echo "File \"$file\" already exists. Use \"gstac!\" force archiving. "; fi; else echo "No tags can describe this commit. "; fi; fi; }; _'
alias ${_GIT_ALIAS_PREFIX}artgz='_() { ish=${1-HEAD}; if [ -n "`git rev-parse --verify $ish`" ]; then ver=`(git describe $ish || git describe --tags $ish) 2> /dev/null`; if [ -n  "$ver" ]; then if [ -n "$2" ]; then file=`echo $2 | sed "s/\(.*\)\.tgz/\1/;s/.*/&.tgz/"`; else file=`basename \`git rev-parse --show-toplevel\``"-$ver".tgz; fi; if [ ! -f "$file" ]; then git archive "$ish" --format=tgz --prefix="$ish/" -o "$file"; else echo "File \"$file\" already exists. Use \"gstac!\" force archiving. "; fi; else echo "No tags can describe this commit. "; fi; fi; }; _'
alias ${_GIT_ALIAS_PREFIX}arzip='_() { ish=${1-HEAD}; if [ -n "`git rev-parse --verify $ish`" ]; then ver=`(git describe $ish || git describe --tags $ish) 2> /dev/null`; if [ -n  "$ver" ]; then if [ -n "$2" ]; then file=`echo $2 | sed "s/\(.*\)\.zip/\1/;s/.*/&.zip/"`; else file=`basename \`git rev-parse --show-toplevel\``"-$ver".zip; fi; if [ ! -f "$file" ]; then git archive "$ish" --format=zip --prefix="$ish/" -o "$file"; else echo "File \"$file\" already exists. Use \"gstac!\" force archiving. "; fi; else echo "No tags can describe this commit. "; fi; fi; }; _'

# gb - git branch
alias ${_GIT_ALIAS_PREFIX}b='git branch'
alias ${_GIT_ALIAS_PREFIX}b!='git branch --force'
alias ${_GIT_ALIAS_PREFIX}ba='git branch -avv'
alias ${_GIT_ALIAS_PREFIX}branches='gba'
alias ${_GIT_ALIAS_PREFIX}bd='git branch -d'
alias ${_GIT_ALIAS_PREFIX}bd!='git branch -D'
alias ${_GIT_ALIAS_PREFIX}bm='git branch -m'
alias ${_GIT_ALIAS_PREFIX}bm!='git branch -M'
alias ${_GIT_ALIAS_PREFIX}bmerged='git branch --merged'
alias ${_GIT_ALIAS_PREFIX}bmerged~='git branch --no-merged'
alias ${_GIT_ALIAS_PREFIX}bnomerged='gbmerged~'
alias ${_GIT_ALIAS_PREFIX}bu='git branch --set-upstream-to`'
alias ${_GIT_ALIAS_PREFIX}bu~='git branch --unset-upstream'
# delete marged branches
alias ${_GIT_ALIAS_PREFIX}bdm='_() { git branch --merged ${1-master} | grep -v " ${1-master}$" | xargs -n 1 git branch -d; }; _'
alias ${_GIT_ALIAS_PREFIX}bdmerged='gbdm'

# gbl -- git blame
alias ${_GIT_ALIAS_PREFIX}bl='git blame -b -w'

# gbs -- git bisect
alias ${_GIT_ALIAS_PREFIX}bs='git bisect'
alias ${_GIT_ALIAS_PREFIX}bsb='git bisect bad'
alias ${_GIT_ALIAS_PREFIX}bsg='git bisect good'
alias ${_GIT_ALIAS_PREFIX}bsr='git bisect run'
alias ${_GIT_ALIAS_PREFIX}bsre='git bisect reset'
alias ${_GIT_ALIAS_PREFIX}bsreset='gbsre'
alias ${_GIT_ALIAS_PREFIX}bss='git bisect start'

# gc - git commit (end with '!' means --amend)
alias ${_GIT_ALIAS_PREFIX}c='git commit -v'
alias ${_GIT_ALIAS_PREFIX}c!='git commit -v --amend'
alias ${_GIT_ALIAS_PREFIX}cgc='git commit --amend --no-edit'
alias ${_GIT_ALIAS_PREFIX}cgc!='gcgc'
alias ${_GIT_ALIAS_PREFIX}ca='git commit -v -a'
alias ${_GIT_ALIAS_PREFIX}ca!='git commit -v -a --amend'
alias ${_GIT_ALIAS_PREFIX}cm='git commit -m'
alias ${_GIT_ALIAS_PREFIX}cm!='git commit --amend -m'
alias ${_GIT_ALIAS_PREFIX}cam='git commit -a -m'
alias ${_GIT_ALIAS_PREFIX}cam!='git commit -a --amend -m'
alias ${_GIT_ALIAS_PREFIX}cmsg='gcm'
alias ${_GIT_ALIAS_PREFIX}cmsg!='gcm!'
alias ${_GIT_ALIAS_PREFIX}camsg='gcam'
alias ${_GIT_ALIAS_PREFIX}camsg!='gcam!'

# gcf -- git config
# Writing operation: Write values into local configuration file by default.
# Reading operation: Read from system, global and local configuration files in sequence by default.
alias ${_GIT_ALIAS_PREFIX}cf='git config'
alias ${_GIT_ALIAS_PREFIX}cfa='git config --add'
alias ${_GIT_ALIAS_PREFIX}cfe='git config --edit'
alias ${_GIT_ALIAS_PREFIX}cfg='git config --get-regexp'
alias ${_GIT_ALIAS_PREFIX}cfl='git config --list'
alias ${_GIT_ALIAS_PREFIX}cff='cat `git rev-parse --git-dir`/config'
alias ${_GIT_ALIAS_PREFIX}cfrm='git config --remove-section'
alias ${_GIT_ALIAS_PREFIX}cfrn='git config --rename-section'
alias ${_GIT_ALIAS_PREFIX}cfso='git config --show-origin'
alias ${_GIT_ALIAS_PREFIX}cfsoa='gcfl | cut -d= -f1 | while read line; do git config --show-origin $line; done'
alias ${_GIT_ALIAS_PREFIX}cfu='git config --unset'
alias ${_GIT_ALIAS_PREFIX}cfua='git config --unset-all'

# gcf~ -- git config --local
# Writing operation: Write values into the .git/config file of repository by default.
# Reading operation: Read only from the .git/config file of repository.
alias ${_GIT_ALIAS_PREFIX}cf~='git config --local'
alias ${_GIT_ALIAS_PREFIX}cfa~='git config --local --add'
alias ${_GIT_ALIAS_PREFIX}cfe~='git config --local --edit'
alias ${_GIT_ALIAS_PREFIX}cfg~='git config --local --get-regexp'
alias ${_GIT_ALIAS_PREFIX}cfl~='git config --local --list'
alias ${_GIT_ALIAS_PREFIX}cff~='cat `git rev-parse --git-dir`/config'
alias ${_GIT_ALIAS_PREFIX}cfrm~='git config --local --remove-section'
alias ${_GIT_ALIAS_PREFIX}cfrn~='git config --local --rename-section'
alias ${_GIT_ALIAS_PREFIX}cfu~='git config --local --unset'
alias ${_GIT_ALIAS_PREFIX}cfua~='git config --local --unset-all'

# gcf! -- git config --global
# Writing operation: Write values into the global ~/.gitconfig file, if this file doesn't exist, write into $XDG_CONFIG_HOME/git/config file if this file exists.
# Reading operation: Read only from global ~/.gitconfig and from $XDG_CONFIG_HOME/git/config rather than from all available files.
alias ${_GIT_ALIAS_PREFIX}cf!='git config --global'
alias ${_GIT_ALIAS_PREFIX}cfa!='git config --global --add'
alias ${_GIT_ALIAS_PREFIX}cfe!='git config --global --edit'
alias ${_GIT_ALIAS_PREFIX}cfg!='git config --global --get-regexp'
alias ${_GIT_ALIAS_PREFIX}cfl!='git config --global --list'
alias ${_GIT_ALIAS_PREFIX}cff!='if [ -f "$HOME/.gitconfig" ]; then cat "$HOME/.gitconfig"; elif [ -f "$XDG_CONFIG_HOME/git/config" ]; then cat "$XDG_CONFIG_HOME/git/config"; fi'
alias ${_GIT_ALIAS_PREFIX}cfrm!='git config --global --remove-section'
alias ${_GIT_ALIAS_PREFIX}cfrn!='git config --global --rename-section'
alias ${_GIT_ALIAS_PREFIX}cfu!='git config --global --unset'
alias ${_GIT_ALIAS_PREFIX}cfua!='git config --global --unset-all'

# gcl -- git clone
alias ${_GIT_ALIAS_PREFIX}cl='git clone --recursive'
alias ${_GIT_ALIAS_PREFIX}clone='gcl'

# gclean! -- git clean
alias ${_GIT_ALIAS_PREFIX}clean!='git clean -df'
alias ${_GIT_ALIAS_PREFIX}clean='echo "Running in dry-run mode. \n Note: Run \"gclean!\" to perform the UNRECOVERABLE clean operation."; git clean -dfn'

# gco -- git checkout
alias ${_GIT_ALIAS_PREFIX}co='git checkout'
alias ${_GIT_ALIAS_PREFIX}co-='git checkout -' # checkout the previous branch
alias ${_GIT_ALIAS_PREFIX}cob='git checkout -b'
alias ${_GIT_ALIAS_PREFIX}coB='git checkout -B' # equal to git branch -f
alias ${_GIT_ALIAS_PREFIX}coo='git checkout --orphan'

# gco~ -- git checkout -m, checkout with three-way merge
alias ${_GIT_ALIAS_PREFIX}co~='git checkout -m'
alias ${_GIT_ALIAS_PREFIX}co-~='git checkout -m -'
alias ${_GIT_ALIAS_PREFIX}cob~='git checkout -m -b'
alias ${_GIT_ALIAS_PREFIX}coB~='git checkout -m -B'
alias ${_GIT_ALIAS_PREFIX}coo~='git checkout -m --orphan'

# gco! -- git checkout -f
alias ${_GIT_ALIAS_PREFIX}co!='git checkout -f'
alias ${_GIT_ALIAS_PREFIX}co-!='git checkout -f -'
alias ${_GIT_ALIAS_PREFIX}cob!='git checkout -f -b'
alias ${_GIT_ALIAS_PREFIX}coB!='git checkout -f -B'
alias ${_GIT_ALIAS_PREFIX}coo!='git checkout -f --orphan'
alias ${_GIT_ALIAS_PREFIX}co~!='git checkout -f -m'
alias ${_GIT_ALIAS_PREFIX}co-~!='git checkout -f -m -'
alias ${_GIT_ALIAS_PREFIX}cob~!='git checkout -f -m -b'
alias ${_GIT_ALIAS_PREFIX}coB~!='git checkout -f -m -B'
alias ${_GIT_ALIAS_PREFIX}coo~!='git checkout -f -m --orphan'

# gcp -- git cherry-pick
alias ${_GIT_ALIAS_PREFIX}cp='git cherry-pick'
alias ${_GIT_ALIAS_PREFIX}cpa -- git cherry-pick --abort
alias ${_GIT_ALIAS_PREFIX}cpc -- git cherry-pick --continue
alias ${_GIT_ALIAS_PREFIX}cpq -- git cherry-pick --quit

# gcount -- git count-objects
alias ${_GIT_ALIAS_PREFIX}count='git count-objects --human-readable'

# gd - git diff, gda - code review
alias ${_GIT_ALIAS_PREFIX}d='git diff'
alias ${_GIT_ALIAS_PREFIX}da='git diff -U99999'
alias ${_GIT_ALIAS_PREFIX}review='gda'
alias ${_GIT_ALIAS_PREFIX}dck='git diff --check'
alias ${_GIT_ALIAS_PREFIX}dw='git diff --word-diff'

# gd! - git diff --cached
alias ${_GIT_ALIAS_PREFIX}d!='git diff --cached'
alias ${_GIT_ALIAS_PREFIX}da!='git diff --cached -U99999'
alias ${_GIT_ALIAS_PREFIX}review!='gda!'
alias ${_GIT_ALIAS_PREFIX}dck!='git diff --cached --check'
alias ${_GIT_ALIAS_PREFIX}dw!='git diff --cached --word-diff'

# gdt -- git diff-tree
# Use '--' to separate paths from revisions, like this:
# 'gdt [<revision>...] -- [<file>...]'
alias ${_GIT_ALIAS_PREFIX}dt='git diff-tree --no-commit-id --name-only -r'

# gdvim -- git difftool --tool=vimdiff
alias ${_GIT_ALIAS_PREFIX}dvim='git difftool --tool=vimdiff -U99999'

# gde -- git describe
alias ${_GIT_ALIAS_PREFIX}de='git describe'
alias ${_GIT_ALIAS_PREFIX}describe='gdesc'
alias ${_GIT_ALIAS_PREFIX}det='git describe --tags'

# gf - git fetch
alias ${_GIT_ALIAS_PREFIX}f='git fetch'
alias ${_GIT_ALIAS_PREFIX}fa='git fetch --all --tags --prune'

# gi - git init
alias ${_GIT_ALIAS_PREFIX}i='git init'
alias ${_GIT_ALIAS_PREFIX}init='gi'
alias ${_GIT_ALIAS_PREFIX}ib='git init --bare'

# gignore, gignored, gignore~, gunignore -- git ignore or unignore files
alias ${_GIT_ALIAS_PREFIX}ignore='git update-index --assume-unchanged'
alias ${_GIT_ALIAS_PREFIX}ignored='git ls-files -v \| grep "^[[:lower:]]"'
# git unignore files
alias ${_GIT_ALIAS_PREFIX}ignore~='git update-index --no-assume-unchanged'
alias ${_GIT_ALIAS_PREFIX}unignore='gignore~'

# glg, glog - git log
alias ${_GIT_ALIAS_PREFIX}lg='git log --oneline --decorate --color'
alias ${_GIT_ALIAS_PREFIX}log='git log --stat --notes --show-signature --decorate --color -p'

# glt - git 'log-tree'
alias ${_GIT_ALIAS_PREFIX}lt='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias ${_GIT_ALIAS_PREFIX}lta='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --all'
# Show the whole log tree including which mentioned by reflogs
alias ${_GIT_ALIAS_PREFIX}ltw='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --all --reflog'

# glast - git 'last-log'
alias ${_GIT_ALIAS_PREFIX}last='git log -1 --notes --show-signature --log-size -p'

# glf -- git ls-files, glf~ -- list untracked files or folders under current dir
alias ${_GIT_ALIAS_PREFIX}lf='git ls-files'
alias ${_GIT_ALIAS_PREFIX}lf~='git ls-files --others --directory'
alias ${_GIT_ALIAS_PREFIX}lfi='git ls-files --others --ignored --exclude-standard --directory'

# gll, gls  -- git ls-tree, list tracked files with properties or tracked files in columns
# suffix 'r' will output sub git repo in new block alone
alias ${_GIT_ALIAS_PREFIX}ll='_() { ls -dlhG $(git ls-tree --name-only ${1-HEAD}) }; _'
alias ${_GIT_ALIAS_PREFIX}ls='_() { ls -dG $(git ls-tree --name-only ${1-HEAD}) }; _'
alias ${_GIT_ALIAS_PREFIX}llr='_() { ls -lhG $(git ls-tree -r --name-only ${1-HEAD}) }; _'
alias ${_GIT_ALIAS_PREFIX}lsr='_() { ls -G $(git ls-tree -r --name-only ${1-HEAD}) }; _'

# gm - git merge
alias ${_GIT_ALIAS_PREFIX}m='git merge'
alias ${_GIT_ALIAS_PREFIX}mnf='git merge --no-ff'
alias ${_GIT_ALIAS_PREFIX}msq='git merge --squash'
alias ${_GIT_ALIAS_PREFIX}msquash='gmsq'

# gmb, ganc -- git merge-base, get common ancestor commit
alias ${_GIT_ALIAS_PREFIX}mb='git merge-base'
alias ${_GIT_ALIAS_PREFIX}anc='gmb'

# gmv -- git mv
alias ${_GIT_ALIAS_PREFIX}mv='git mv'

# gp - git push, gpp - git push all branches and their tags
alias ${_GIT_ALIAS_PREFIX}p='git push'
alias ${_GIT_ALIAS_PREFIX}pu='git push -u'
alias ${_GIT_ALIAS_PREFIX}pdb='git push --delete'
alias ${_GIT_ALIAS_PREFIX}pp='_() {git push $1 && git push --tags $1}; _'
alias ${_GIT_ALIAS_PREFIX}pd='git push --dry-run'
alias ${_GIT_ALIAS_PREFIX}pdr='gpd'
alias ${_GIT_ALIAS_PREFIX}pt='git push --tags'

# gp! - git push --force
alias ${_GIT_ALIAS_PREFIX}p!='git push --force'
alias ${_GIT_ALIAS_PREFIX}pu!='git push --force -u'
alias ${_GIT_ALIAS_PREFIX}pp!='_() {git push --force $1 && git push --tags --force $1}; _'
alias ${_GIT_ALIAS_PREFIX}pd!='git push --dry-run --force'
alias ${_GIT_ALIAS_PREFIX}pdr!='gpd!'
alias ${_GIT_ALIAS_PREFIX}pt!='git push --tags --force'

# gpl -- git pull
alias ${_GIT_ALIAS_PREFIX}pl='git pull --tags'
alias ${_GIT_ALIAS_PREFIX}plr='git pull --tags --rebase'

# gr - git remote
alias ${_GIT_ALIAS_PREFIX}r='git remote -v'
alias ${_GIT_ALIAS_PREFIX}ra='git remote add'
alias ${_GIT_ALIAS_PREFIX}rrm='git remote remove'
alias ${_GIT_ALIAS_PREFIX}rrn='git remote rename'
alias ${_GIT_ALIAS_PREFIX}rgu='git remote get-url'
alias ${_GIT_ALIAS_PREFIX}rsu='git remote set-url'
alias ${_GIT_ALIAS_PREFIX}rp='git remote prune'
alias ${_GIT_ALIAS_PREFIX}ru='git remote update'

# grb -- git rebase
alias ${_GIT_ALIAS_PREFIX}rb='git rebase'
alias ${_GIT_ALIAS_PREFIX}rbi='git rebase -i'
alias ${_GIT_ALIAS_PREFIX}rba='git rebase --abort'
alias ${_GIT_ALIAS_PREFIX}rbc='git rebase --continue'
alias ${_GIT_ALIAS_PREFIX}rbs='git rebase --skip'
alias ${_GIT_ALIAS_PREFIX}rbon='git rebase --onto'

# grm -- git rm, grm~ -- untrack file[s]
alias ${_GIT_ALIAS_PREFIX}rm='git rm'
alias ${_GIT_ALIAS_PREFIX}rm~='git rm --cached'

# grs -- git reset --mixed
alias ${_GIT_ALIAS_PREFIX}rs='git reset --mixed'
alias ${_GIT_ALIAS_PREFIX}rsh='git reset --mixed HEAD --'
alias ${_GIT_ALIAS_PREFIX}unstage='grsh'

# grs~ -- git reset --soft
alias ${_GIT_ALIAS_PREFIX}rs~='git reset --soft'
alias ${_GIT_ALIAS_PREFIX}rsh~='git reset --soft HEAD --'
alias ${_GIT_ALIAS_PREFIX}unstage~='grsh~'

# grs! -- git reset --hard
alias ${_GIT_ALIAS_PREFIX}rs!='git reset --hard'
alias ${_GIT_ALIAS_PREFIX}rsh!='git reset --hard HEAD --'
alias ${_GIT_ALIAS_PREFIX}unstage!='grsh!'

# grt -- git root
alias ${_GIT_ALIAS_PREFIX}rt='cd $(git rev-parse --show-toplevel || echo ".")'
alias ${_GIT_ALIAS_PREFIX}root='grt'

# grv -- git revert
alias ${_GIT_ALIAS_PREFIX}rv='git revert'
alias ${_GIT_ALIAS_PREFIX}rva='git revert --abort'
alias ${_GIT_ALIAS_PREFIX}rvc='git revert --continue'
alias ${_GIT_ALIAS_PREFIX}rvq='git revert --quit'

# gs - git status
alias ${_GIT_ALIAS_PREFIX}s='git status -sb'
alias ${_GIT_ALIAS_PREFIX}ss='git status --ignored'
alias ${_GIT_ALIAS_PREFIX}st='git -c pager.status=less status -vv'

# gshow, gcat -- git show/cat file content
# Show file content for specific file: gshow HEAD@{2018-08-01}:example.txt
alias ${_GIT_ALIAS_PREFIX}show='git show'
alias ${_GIT_ALIAS_PREFIX}cat='git cat-file -p'

# gsl -- git shortlog
alias ${_GIT_ALIAS_PREFIX}sl='git shortlog'
alias ${_GIT_ALIAS_PREFIX}slnm='git shortlog --no-merges'

# gsm -- git submodule
alias ${_GIT_ALIAS_PREFIX}sm='git submodule'
alias ${_GIT_ALIAS_PREFIX}sma='git submodule add'
alias ${_GIT_ALIAS_PREFIX}smf='git submodule foreach'
alias ${_GIT_ALIAS_PREFIX}smfr='git submodule foreach --recursive'
alias ${_GIT_ALIAS_PREFIX}smi='git submodule init'
alias ${_GIT_ALIAS_PREFIX}smi~='git submodule deinit'
alias ${_GIT_ALIAS_PREFIX}smi~!='git submodule deinit --force'
alias ${_GIT_ALIAS_PREFIX}smdi='gsmi~'
alias ${_GIT_ALIAS_PREFIX}smdi!='gsmi~!'
alias ${_GIT_ALIAS_PREFIX}sms='git submodule status --recursive'
alias ${_GIT_ALIAS_PREFIX}smsum='git submodule summary'
alias ${_GIT_ALIAS_PREFIX}smsummary='gsmsum'
alias ${_GIT_ALIAS_PREFIX}smsync='git submodule sync --recursive'
alias ${_GIT_ALIAS_PREFIX}smu='git submodule update --init --recursive'
alias ${_GIT_ALIAS_PREFIX}smpla='_() { git submodule foreach --recursive git pull ${1-origin} ${2-master} }; _'
alias ${_GIT_ALIAS_PREFIX}smpla!='_() { git submodule foreach --recursive git pull --force ${1-origin} ${2-master} }; _'

# gsta -- git stash
alias ${_GIT_ALIAS_PREFIX}sta='git stash'
alias ${_GIT_ALIAS_PREFIX}stau='git stash --include-untracked' # Above git version 1.7.7, use it replace gwip
alias ${_GIT_ALIAS_PREFIX}staa='git stash apply'
alias ${_GIT_ALIAS_PREFIX}stac!='git stash clear'
alias ${_GIT_ALIAS_PREFIX}stac='echo "CAUTION: Use \"gstac!\" to clear all stored stashes."'
alias ${_GIT_ALIAS_PREFIX}stad!='git stash drop'
alias ${_GIT_ALIAS_PREFIX}stad='echo "CAUTION: Use \"gstad!\" to drop the stash."'
alias ${_GIT_ALIAS_PREFIX}stal='git stash list'
alias ${_GIT_ALIAS_PREFIX}stap='git stash pop'
alias ${_GIT_ALIAS_PREFIX}stas='git stash show --text'

# gt - git tag && verify-tag
alias ${_GIT_ALIAS_PREFIX}t='git tag'
alias ${_GIT_ALIAS_PREFIX}ta='git tag -a'
alias ${_GIT_ALIAS_PREFIX}ts='git tag -s'
alias ${_GIT_ALIAS_PREFIX}tp='gpt'
alias ${_GIT_ALIAS_PREFIX}tp!='gpt!'
alias ${_GIT_ALIAS_PREFIX}tv='git tag -v'
alias ${_GIT_ALIAS_PREFIX}vt='git verify-tag'

# gwip - git wip(Work in Progress)
alias ${_GIT_ALIAS_PREFIX}wip='git add -A && git rm $(git ls-files --deleted) 2> /dev/null; git commit -m "--wip--" && echo "WIP\!"'
alias ${_GIT_ALIAS_PREFIX}unwip='git log -n 1 | grep -q -c -- "--wip--" && git reset HEAD~1'
alias ${_GIT_ALIAS_PREFIX}wip~='gunwip'

# gwipe -- git wipe current work and leave a wipe savepoint
alias ${_GIT_ALIAS_PREFIX}wipe='git add -A && git rm $(git ls-files --deleted) 2> /dev/null; git commit -qm "WIPE SAVEPOINT" && git reset HEAD~1 --hard'
