# galias - get git aliases
export _GITALIASFILE="$0"
function galias() {
    string=$(echo "$1" | sed 's/./&\.*/g')
    sed -n "/^#\ g.*-\{1,2\}.*$string/,/^$/p" "$_GITALIASFILE" | sed '${/^$/d;}'
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
#| gsta -- git stash
#| gt - git tag && verify-tag
#| gwip - git wip(Work in Progress)
#| gwipe -- git wipe current work and leave a wipe savepoint

# g - git
alias g='git'

# ga - git add
alias ga='git add'
alias ga!='git add --force'
alias gaa='git add --all'
alias gap='git add --patch'
alias gapa='gap'
alias gai='git add --interactive'
alias gau='git add --update'
# gac -- git add && commit
alias gac='git add -A . && git commit'
alias gac!='git add -A . && git commit --amend'
alias gacm='git add -A . && git commit -m'
alias gacm!='git add -A . && git commit --amend -m'
alias gacmsg='gacm'
alias gacmsg!='gacmsg'

# gar -- git archive
alias gar='git archive'
alias gargz='_() { ish=${1-HEAD}; if [ -n "`git rev-parse --verify $ish`" ]; then ver=`(git describe $ish || git describe --tags $ish) 2> /dev/null`; if [ -n  "$ver" ]; then if [ -n "$2" ]; then file=`echo $2 | sed "s/\(.*\)\.tar.gz/\1/;s/.*/&.tar.gz/"`; else file=`basename \`git rev-parse --show-toplevel\``"-$ver".tar.gz; fi; if [ ! -f "$file" ]; then git archive "$ish" --format=tar.gz --prefix="$ish/" -o "$file"; else echo "File \"$file\" already exists. Use \"gstac!\" force archiving. "; fi; else echo "No tags can describe this commit. "; fi; fi; }; _'
alias gartar='_() { ish=${1-HEAD}; if [ -n "`git rev-parse --verify $ish`" ]; then ver=`(git describe $ish || git describe --tags $ish) 2> /dev/null`; if [ -n  "$ver" ]; then if [ -n "$2" ]; then file=`echo $2 | sed "s/\(.*\)\.tar/\1/;s/.*/&.tar/"`; else file=`basename \`git rev-parse --show-toplevel\``"-$ver".tar; fi; if [ ! -f "$file" ]; then git archive "$ish" --format=tar --prefix="$ish/" -o "$file"; else echo "File \"$file\" already exists. Use \"gstac!\" force archiving. "; fi; else echo "No tags can describe this commit. "; fi; fi; }; _'
alias gartgz='_() { ish=${1-HEAD}; if [ -n "`git rev-parse --verify $ish`" ]; then ver=`(git describe $ish || git describe --tags $ish) 2> /dev/null`; if [ -n  "$ver" ]; then if [ -n "$2" ]; then file=`echo $2 | sed "s/\(.*\)\.tgz/\1/;s/.*/&.tgz/"`; else file=`basename \`git rev-parse --show-toplevel\``"-$ver".tgz; fi; if [ ! -f "$file" ]; then git archive "$ish" --format=tgz --prefix="$ish/" -o "$file"; else echo "File \"$file\" already exists. Use \"gstac!\" force archiving. "; fi; else echo "No tags can describe this commit. "; fi; fi; }; _'
alias garzip='_() { ish=${1-HEAD}; if [ -n "`git rev-parse --verify $ish`" ]; then ver=`(git describe $ish || git describe --tags $ish) 2> /dev/null`; if [ -n  "$ver" ]; then if [ -n "$2" ]; then file=`echo $2 | sed "s/\(.*\)\.zip/\1/;s/.*/&.zip/"`; else file=`basename \`git rev-parse --show-toplevel\``"-$ver".zip; fi; if [ ! -f "$file" ]; then git archive "$ish" --format=zip --prefix="$ish/" -o "$file"; else echo "File \"$file\" already exists. Use \"gstac!\" force archiving. "; fi; else echo "No tags can describe this commit. "; fi; fi; }; _'

# gb - git branch
alias gb='git branch'
alias gb!='git branch --force'
alias gba='git branch -avv'
alias gbranches='gba'
alias gbd='git branch -d'
alias gbd!='git branch -D'
alias gbm='git branch -m'
alias gbm!='git branch -M'
alias gbmerged='git branch --merged'
alias gbmerged~='git branch --no-merged'
alias gbnomerged='gbmerged~'
alias gbu='git branch --set-upstream-to`'
alias gbu~='git branch --unset-upstream'
# delete marged branches
alias gbdm='_() { git branch --merged ${1-master} | grep -v " ${1-master}$" | xargs -n 1 git branch -d; }; _'
alias gbdmerged='gbdm'

# gbl -- git blame
alias gbl='git blame -b -w'

# gbs -- git bisect
alias gbs='git bisect'
alias gbsb='git bisect bad'
alias gbsg='git bisect good'
alias gbsr='git bisect run'
alias gbsre='git bisect reset'
alias gbsreset='gbsre'
alias gbss='git bisect start'

# gc - git commit (end with '!' means --amend)
alias gc='git commit -v'
alias gc!='git commit -v --amend'
alias gc!!='git commit --amend --no-edit'
alias gca='git commit -v -a'
alias gca!='git commit -v -a --amend'
alias gcm='git commit -m'
alias gcm!='git commit --amend -m'
alias gcam='git commit -a -m'
alias gcam!='git commit -a --amend -m'
alias gcmsg='gcm'
alias gcmsg!='gcm!'
alias gcamsg='gcam'
alias gcamsg!='gcam!'

# gcf -- git config
alias gcf='git config'
alias gcfa='git config --add'
alias gcfg='git config --get'
alias gcfl='git config --list'
alias gcff='cat `git rev-parse --git-dir`/config'
alias gcfrm='git config --remove-section'
alias gcfrn='git config --rename-section'
alias gcfu='git config --unset'
alias gcfua='git config --unset-all'

# gcf~ -- git config --local
alias gcf~='git config --local'
alias gcfa~='git config --local --add'
alias gcfg~='git config --local --get'
alias gcfl~='git config --local --list'
alias gcff~='cat `git rev-parse --git-dir`/config'
alias gcfrm~='git config --local --remove-section'
alias gcfrn~='git config --local --rename-section'
alias gcfu~='git config --local --unset'
alias gcfua~='git config --local --unset-all'

# gcf! -- git config --global
alias gcf!='git config --global'
alias gcfa!='git config --global --add'
alias gcfg!='git config --global --get'
alias gcfl!='git config --global --list'
alias gcff!='if [ -f "$HOME/.gitconfig" ]; then cat "$HOME/.gitconfig"; elif [ -f "$XDG_CONFIG_HOME/git/config" ]; then cat "$XDG_CONFIG_HOME/git/config"; fi'
alias gcfrm!='git config --global --remove-section'
alias gcfrn!='git config --global --rename-section'
alias gcfu!='git config --global --unset'
alias gcfua!='git config --global --unset-all'

# gcl -- git clone
alias gcl='git clone --recursive'
alias gclone='gcl'

# gclean! -- git clean
alias gclean!='git clean -df'
alias gclean='echo "Running in dry-run mode. \n Note: Run \"gclean!\" to perform the UNRECOVERABLE clean operation."; git clean -dfn'

# gco -- git checkout
alias gco='git checkout'
alias gco-='git checkout -' # checkout the previous branch
alias gcob='git checkout -b'
alias gcoB='git checkout -B' # equal to git branch -f
alias gcoo='git checkout --orphan'

# gco~ -- git checkout -m, checkout with three-way merge
alias gco~='git checkout -m'
alias gco-~='git checkout -m -'
alias gcob~='git checkout -m -b'
alias gcoB~='git checkout -m -B'
alias gcoo~='git checkout -m --orphan'

# gco! -- git checkout -f
alias gco!='git checkout -f'
alias gco-!='git checkout -f -'
alias gcob!='git checkout -f -b'
alias gcoB!='git checkout -f -B'
alias gcoo!='git checkout -f --orphan'
alias gco~!='git checkout -f -m'
alias gco-~!='git checkout -f -m -'
alias gcob~!='git checkout -f -m -b'
alias gcoB~!='git checkout -f -m -B'
alias gcoo~!='git checkout -f -m --orphan'

# gcp -- git cherry-pick
alias gcp='git cherry-pick'

# gcount -- git count-objects
alias gcount='git count-objects --human-readable'

# gd - git diff, gda - code review
alias gd='git diff'
alias gda='git diff -U99999'
alias greview='gda'
alias gdck='git diff --check'
alias gdw='git diff --word-diff'

# gd! - git diff --cached
alias gd!='git diff --cached'
alias gda!='git diff --cached -U99999'
alias greview!='gda!'
alias gdck!='git diff --cached --check'
alias gdw!='git diff --cached --word-diff'

# gdt -- git diff-tree
# Use '--' to separate paths from revisions, like this:
# 'gdt [<revision>...] -- [<file>...]'
alias gdt='git diff-tree --no-commit-id --name-only -r'

# gde -- git describe
alias gde='git describe'
alias gdescribe='gdesc'
alias gdet='git describe --tags'

# gf - git fetch
alias gf='git fetch'
alias gfa='git fetch --all --tags --prune'

# gi - git init
alias gi='git init'
alias ginit='gi'
alias gib='git init --bare'

# gignore, gignored, gignore~, gunignore -- git ignore or unignore files
alias gignore='git update-index --assume-unchanged'
alias gignored='git ls-files -v \| grep "^[[:lower:]]"'
# git unignore files
alias gignore~='git update-index --no-assume-unchanged'
alias gunignore='gignore~'

# glg, glog - git log
alias glg='git log --oneline --decorate --color'
alias glog='git log --stat --notes --show-signature --decorate --color -p'

# glt - git 'log-tree'
alias glt='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias glta='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --all'
# Show the whole log tree including which mentioned by reflogs
alias gltw='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --all --reflog'

# glast - git 'last-log'
alias glast='git log -1 --notes --show-signature --log-size -p'

# glf -- git ls-files, glf~ -- list untracked files or folders under current dir
alias glf='git ls-files'
alias glf~='git ls-files --others --directory'
alias glfi='git ls-files --others --ignored --exclude-standard --directory'

# gll, gls  -- git ls-tree, list tracked files with properties or tracked files in columns
# suffix 'r' will output sub git repo in new block alone
alias gll='_() { ls -dlhG $(git ls-tree --name-only ${1-HEAD}) }; _'
alias gls='_() { ls -dG $(git ls-tree --name-only ${1-HEAD}) }; _'
alias gllr='_() { ls -lhG $(git ls-tree -r --name-only ${1-HEAD}) }; _'
alias glsr='_() { ls -G $(git ls-tree -r --name-only ${1-HEAD}) }; _'

# gm - git merge
alias gm='git merge'

# gmb, ganc -- git merge-base, get common ancestor commit
alias gmb='git merge-base'
alias ganc='gmb'

# gmv -- git mv
alias gmv='git mv'

# gp - git push, gpp - git push all branches and their tags
alias gp='git push'
alias gpu='git push -u'
alias gpdb='git push --delete'
alias gpp='_() {git push $1 && git push --tags $1}; _'
alias gpd='git push --dry-run'
alias gpdr='gpd'
alias gpt='git push --tags'

# gp! - git push --force
alias gp!='git push --force'
alias gpu!='git push --force -u'
alias gpp!='_() {git push --force $1 && git push --tags --force $1}; _'
alias gpd!='git push --dry-run --force'
alias gpdr!='gpd!'
alias gpt!='git push --tags --force'

# gpl -- git pull
alias gpl='git pull --tags'
alias gplr='git pull --tags --rebase'

# gr - git remote
alias gr='git remote -v'
alias gra='git remote add'
alias grrm='git remote remove'
alias grrn='git remote rename'
alias grgu='git remote get-url'
alias grsu='git remote set-url'
alias grp='git remote prune'
alias gru='git remote update'

# grb -- git rebase
alias grb='git rebase'
alias grbi='git rebase -i'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbs='git rebase --skip'

# grm -- git rm, grm~ -- untrack file[s]
alias grm='git rm'
alias grm~='git rm --cached'

# grs -- git reset --mixed
alias grs='git reset --mixed'
alias grsh='git reset --mixed HEAD --'
alias gunstage='grsh'

# grs~ -- git reset --soft
alias grs~='git reset --soft'
alias grsh~='git reset --soft HEAD --'
alias gunstage~='grsh~'

# grs! -- git reset --hard
alias grs!='git reset --hard'
alias grsh!='git reset --hard HEAD --'
alias gunstage!='grsh!'

# grt -- git root
alias grt='cd $(git rev-parse --show-toplevel || echo ".")'
alias groot='grt'

# grv -- git revert
alias grv='git revert'
alias grva='git revert --abort'
alias grvc='git revert --continue'
alias grvq='git revert --quit'

# gs - git status
alias gs='git status -sb'
alias gss='git status --ignored'
alias gst='git -c pager.status=less status -vv'

# gshow, gcat -- git show/cat file content
# Show file content for specific file: gshow HEAD@{2018-08-01}:example.txt
alias gshow='git show'
alias gcat='gshow'

# gsl -- git shortlog
alias gsl='git shortlog'

# gsta -- git stash
alias gsta='git stash'
alias gstau='git stash --include-untracked' # Above git version 1.7.7, use it replace gwip
alias gstaa='git stash apply'
alias gstac!='git stash clear'
alias gstac='echo "CAUTION: Use \"gstac!\" to clear all stored stashes."'
alias gstad!='git stash drop'
alias gstad='echo "CAUTION: Use \"gstad!\" to drop the stash."'
alias gstal='git stash list'
alias gstap='git stash pop'
alias gstas='git stash show --text'

# gt - git tag && verify-tag
alias gt='git tag'
alias gta='git tag -a'
alias gts='git tag -s'
alias gtv='git tag -v'
alias gvt='git verify-tag'

# gwip - git wip(Work in Progress)
alias gwip='git add -A && git rm $(git ls-files --deleted) 2> /dev/null; git commit -m "--wip--" && echo "WIP\!"'
alias gunwip='git log -n 1 | grep -q -c -- "--wip--" && git reset HEAD~1'
alias gwip~='gunwip'

# gwipe -- git wipe current work and leave a wipe savepoint
alias gwipe='git add -A && git rm $(git ls-files --deleted) 2> /dev/null; git commit -qm "WIPE SAVEPOINT" && git reset HEAD~1 --hard'
