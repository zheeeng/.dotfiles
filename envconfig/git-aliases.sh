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
#| gcp -- git cherry-pick
#| gd - git diff
#| gf - git fetch
#| gignore, gignored, gignore~, gunignore - git ignore or unignore files
#| glg, glog - git log
#| glt - git 'log-tree'
#| glast - git 'last-log'
#| gls -- git ls-files
#| gm - git merge
#| gp - git push, gp! - git push all branches and their tags!
#| gpl -- git pull
#| gr - git remote
#| grb -- git rebase
#| grs -- git reset
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
alias gaa='git add --all'
alias gapa='git add --patch'
# gac -- git add && commit
alias gac='git add -A . && git commit'
alias gac!='git add -A . && git commit --amend'
alias gacm='git add -A . && git commit -m'
alias gacm!='git add -A . && git commit --amend -m'
alias gacmsg='gacm'
alias gacmsg!='gacmsg'

# gb - git branch
alias gb='git branch'
alias gba='git branch -avv'
alias gbranches='gba'
alias gbm='git branch --merged'
alias gbnm='git branch --no-merged'
alias gbus='git branch --set-upstream-to`'
# unset branch upstream
alias gbus~='git branch --unset-upstream'
alias gbunus='gbus~'
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

# gco -- git checkout
alias gco='git checkout'
alias gcob='git checkout -b'

# gcp -- git cherry-pick
alias gcp='git cherry-pick'

# gd - git diff
alias gd='git diff'
alias gdca='git diff --cached'
alias gdck='git diff --check'
alias gdcc='git diff --cached --check'
alias gdt='git diff-tree --no-commit-id --name-only -r'
alias gdw='git diff --word-diff'
alias gdwc='git diff --cached --word-diff'

# gf - git fetch
alias gf='git fetch'
alias gfa='git fetch --all --tags --prune'

# gignore, gignored, gignore~, gunignore - git ignore or unignore files
alias gignore='git update-index --assume-unchanged'
alias gignored='git ls-files -v \| grep "^[[:lower:]]"'
# git unignore files
alias gignore~='git update-index --no-assume-unchanged'
alias gunignore='gignore~'

# glg, glog - git log
alias glg='git log --oneline --decorate --color'
alias glog='git log --stat --decorate --color -p'

# glt - git 'log-tree'
alias glt='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias glta='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --all'
# Show the whole log tree including which mentioned by reflogs
alias gltw='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --all --reflog'

# glast - git 'last-log'
alias glast='git log -1 --log-size -p'

# gls -- git ls-files
alias gls='git ls-files'
alias gls~='git ls-files --others --exclude-standard'

# gm - git merge
alias gm='git merge'

# gmb, ganc -- git merge-base, get common ancestor commit
alias gmb='git merge-base'
alias ganc='gmb'

# gp - git push, gp! - git push all branches and their tags!
alias gp='git push'
alias gpu='git push -u'
alias gp!='_() {git push $1 && git push --tags $1}; _'
alias gpd='git push --dry-run'
alias gpdr='gpd'
alias gpt='git push --tags'

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
alias grs='git remote show'
alias gru='git remote update'

# grb -- git rebase
alias grb='git rebase'
alias grbi='git rebase -i'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbs='git rebase --skip'

# grs -- git reset
alias grs='git reset HEAD --'
alias grsh='git reset HEAD'
alias grsh!='git reset --hard HEAD'

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
alias gstaa='git stash apply'
alias gstad='git stash drop'
alias gstal='git stash list'
alias gstap='git stash list pop'
alias gstas='git stash list show --text'

# gt - git tag && verify-tag
alias gt='git tag'
alias gts='git tag -s'
alias gtv='git tag -v'
alias gvt='git verify-tag'

# gwip - git wip(Work in Progress)
alias gwip='git add -A && git rm $(git ls-files --deleted) 2> /dev/null; git commit -m "--wip--" && echo "WIP\!"'
alias gunwip='git log -n 1 | grep -q -c -- "--wip--" && git reset HEAD~1'
alias gwip~='gunwip'

# gwipe -- git wipe current work and leave a wipe savepoint
alias gwipe='git add -A && git rm $(git ls-files --deleted) 2> /dev/null; git commit -qm "WIPE SAVEPOINT" && git reset HEAD~1 --hard'
