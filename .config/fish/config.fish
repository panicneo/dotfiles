# Base16 Shell
if status --is-interactive
    set BASE16_SHELL "$HOME/.config/base16-shell/"
    source "$BASE16_SHELL/profile_helper.fish"
end

set -x LIBRARY_PATH /usr/local/opt/openssl/lib/

set -x GPG_TTY (tty)

set -x LANG en_US.UTF-8
set -x LC_ALL en_US.UTF-8
set -x EDITOR nvim
set -x SSH_KEY_PATH ~/.ssh/rsa_id
set -x PATH /usr/local/sbin $PATH

set -x PATH $HOME/.krew/bin $PATH


# python
set -x PATH $CONDA_PREFIX/bin $PATH


# golang
set -x GOPATH $HOME/go
set -x GOPROXY https://goproxy.cn
set -x PATH $PATH $GOPATH/bin

# rust
source $HOME/.cargo/env
export RUST_SRC_PATH=~/.rustup/toolchains/stable-x86_64-apple-darwin/lib/rustlib/src/rust/src

# homebrew
set -x HOMEBREW_NO_AUTO_UPDATE 1


# =============================================
#       alias
# =============================================
abbr -a vi "nvim"
abbr -a glm "git log --no-merges --color --date=format:'%Y-%m-%d %H:%M:%S' --author='pengfei\|itsneo1990' --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Cblue %s %Cgreen(%cd) %C(bold blue)<%an>%Creset' --abbrev-commit"
abbr -a glms "git log --no-merges --color --stat --date=format:'%Y-%m-%d %H:%M:%S' --author='pengfei\|itsneo1990' --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Cblue %s %Cgreen(%cd) %C(bold blue)<%an>%Creset' --abbrev-commit"
abbr -a t 'tmux attach -t NEO || tmux new -s NEO'
abbr -a k "kubectl"

# exa
if command -v exa > /dev/null
	abbr -a l   'exa'
	abbr -a ls  'exa'
    abbr -a la  'exa -a'
    abbr -a ll  'exa -lhmgU --time-style=long-iso --git'
    abbr -a lla 'exa -lahmgU --time-style=long-iso --git'
    abbr -a lt  'exa -T'
    abbr -a lr  'exa -R'
else
	abbr -a l   'ls'
	abbr -a ll  'ls -l'
    abbr -a lla 'll -a'
end


# =============================================
#       functions
# =============================================
function pp
    # set -lx HTTP_PROXY 'http://127.0.0.1:1087';
    # set -lx HTTPS_PROXY 'http://127.0.0.1:1087';
    set -lx HTTP_PROXY 'http://10.9.8.2:3128';
    set -lx HTTPS_PROXY 'http://10.9.8.2:3128';
    set -lx ALL_PROXY 'http://10.9.8.2:3128';
    $argv
end

# kill port
function killp
    for port in $argv
        lsof -i :$port | awk 'NR != 1 {print $2}' | xargs -t kill -9
    end
end

# git diff-so-fancy
function gitt 
    set commit_hash "echo {} | grep -o '[a-f0-9]\{7\}' "
    set view_commit "$commit_hash | xargs -I % sh -c 'git show --color=always % | diff-so-fancy'"
    git log --color=always \
        --format="%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" |
        fzf --no-sort --tiebreak=index --no-multi --reverse --ansi \
            --header="enter to view, alt-y to copy hash" --preview="$view_commit" \
            --bind="enter:execute:$view_commit | less -R" \
            --bind="alt-y:execute:$commit_hash | xclip -selection clipboard"
end

# =============================================
#       K8s
# =============================================
alias k-pc-k8s="export KUBECONFIG=/Users/itsneo1990/.kube/pc-k8s"


# snake case to camelcase
function camelcase
    perl -pe 's#(_|^)(.)#\u$2#g'
end


function sudo --description "Replacement for Bash 'sudo !!' command to run last command using sudo."
    if test "$argv" = !!
    eval command sudo $history[1]
else
    command sudo $argv
    end
end

function clean_git
    echo "Clean all git commit"
    git checkout --orphan latest_branch
    git add -A
    git commit -am "Delete all previous commit"
    git branch -D master
    git branch -m master

    echo "Cleanup refs and logs"
    rm -Rf .git/refs/original
    rm -Rf .git/logs/

    echo "Cleanup unnecessary files"
    git gc --aggressive --prune=now

    echo "Prune all unreachable objects"
    git prune --expire now

    #git push -f origin master
end


starship init fish | source

# autojump
[ -f /usr/local/share/autojump/autojump.fish ]; and source /usr/local/share/autojump/autojump.fish

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval /opt/miniconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

thefuck --alias -r | source
