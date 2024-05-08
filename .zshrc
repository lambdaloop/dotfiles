# Path to your oh-my-zsh installation.
export ZSH=/home/lili/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# if [ -n "$INSIDE_EMACS" ]; then
#     export ZSH_THEME="fishy-emacs"
# else
#     export ZSH_THEME="fishy-custom"
# fi

export ZSH_THEME=""

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git colored-man-pages z pass nix-shell sd)
# if [ -z "$INSIDE_EMACS" ]; then
plugins+=zsh-autosuggestions
# fi


# User configuration

export BROWSER=firefox

export PATH=/home/lili/bin:$PATH
export PATH=/home/lili/.local/bin:$PATH

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export TERM=xterm-256color

export SHELL=$(which zsh)

# if [ -n "$INSIDE_EMACS" ]; then
#     ## this setups the path properly
#     export TERM="eterm-color"
#     chpwd() { print -P "\033AnSiTc %d" }
#     print -P "\033AnSiTu %n"
#     print -P "\033AnSiTc %d"
#     unsetopt PROMPT_SP
# fi


function list_all() {
    emulate -L zsh
    ls --color -v
}

chpwd_functions=(${chpwd_functions[@]} "list_all")

# unregister broken GHC packages. Run this a few times to resolve dependency rot in installed packages.
# ghc-pkg-clean -f cabal/dev/packages*.conf also works.
function ghc-pkg-clean() {
    for p in `ghc-pkg check $* 2>&1  | grep problems | awk '{print $6}' | sed -e 's/:$//'`
    do
        echo unregistering $p; ghc-pkg $* unregister $p
    done
}

function matrun() {
    matlab -nosplash -nodesktop -r $(basename $1 .m)
}

function matrunq() {
    filename=$(basename $1 .m)
    matlab -nosplash -nodesktop -r "$filename; quit"
}

# remove all installed GHC/cabal packages, leaving ~/.cabal binaries and docs in place.
# When all else fails, use this to get out of dependency hell and start over.
function ghc-pkg-reset() {
    if [[ $(readlink -f /proc/$$/exe) =~ zsh ]]; then
        read 'ans?Erasing all your user ghc and cabal packages - are you sure (y/N)? '
    else # assume bash/bash compatible otherwise
        read -p 'Erasing all your user ghc and cabal packages - are you sure (y/N)? ' ans
    fi

    [[ x$ans =~ "xy" ]] && ( \
                             echo 'erasing directories under ~/.ghc'; command rm -rf `find ~/.ghc/* -maxdepth 1 -type d`; \
                             echo 'erasing ~/.cabal/lib'; command rm -rf ~/.cabal/lib; \
        )
}

alias cabalupgrades="cabal list --installed  | egrep -iv '(synopsis|homepage|license)'"

setopt COMPLETE_ALIASES

export DISABLE_AUTO_UPDATE="true"
export DISABLE_MAGIC_FUNCTIONS="true" # no paste business

source $ZSH/oh-my-zsh.sh

source ~/dotfiles/scripts/setenv.sh

# add fzf to reverse history search
# source /usr/share/doc/fzf/examples/key-bindings.zsh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'

alias ls='ls --color=tty -v'
alias l='ls --color=tty -v'
alias rs='rsync -ah --info=progress2'
alias rsog='rsync -ah --info=progress2 --no-perms --no-owner --no-group --no-times'
alias doc2pdf="loffice --headless --convert-to pdf:writer_pdf_Export"
# alias kobo="k2pdfopt -ui- -h 1927 -w 1404 -dpi 200 -fc-"
alias kobo="k2pdfopt -ui- -h 1727 -w 1304 -dpi 300 -fc- -x" # use smaller width for margin
alias open="xdg-open"
alias ot="xdg-open . &"

alias sa="source activate"
alias ca="conda activate"

alias tp='tmux attach -t lili'

alias callisto='ssh -o StrictHostKeyChecking=no lili@$(ssh callisto "curl -s -6 ifconfig.co")'

function tomp4() {
    ffmpeg -i $1 -vcodec h264 -pix_fmt yuv420p -qp 28 $2
}

source ~/.oh-my-zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh  

export DISABLE_AUTO_TITLE="true"

local HAPPY_WORDS="/home/lili/dotfiles/lists/happy_articles.txt"
local HAPPY_FACES="/home/lili/dotfiles/lists/happy_emoticons.txt"

function greet() {
    printf "Welcome to $fg_bold[blue]zsh$reset_color.\nHave $fg_bold[green]%s$reset_color day! %s \n" \
           "$(shuf $HAPPY_WORDS | head -1)" "$(shuf $HAPPY_FACES | head -1)"
}


function conda-shell {
    if [ -n "$1" ]; then
        echo "source activate $1; zsh" > ~/tmp/conda_chainer.sh
    else
        echo 'zsh' > ~/tmp/conda_chainer.sh
    fi
    command nix-shell ~/dotfiles/nixos/shells/conda-shell.nix
}

# nvm init
source /usr/share/nvm/init-nvm.sh

# eval "$(starship init zsh)"
fpath+=$HOME/builds/pure
autoload -U promptinit; promptinit
prompt pure
# unsetopt prompt_cr prompt_sp

echo ""
greet



# node version manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# source /etc/zsh_command_not_found
## emacs vterm prompt
function vterm_printf(){
    if [ -n "$TMUX" ]; then
        # Tell tmux to pass the escape sequences through
        # (Source: http://permalink.gmane.org/gmane.comp.terminal-emulators.tmux.user/1324)
        printf "\ePtmux;\e\e]%s\007\e\\" "$1"
    elif [ "${TERM%%-*}" = "screen" ]; then
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$1"
    else
        printf "\e]%s\e\\" "$1"
    fi
}

vterm_prompt_end() {
    vterm_printf "51;A$(whoami)@$(hostname):$(pwd)";
}

setopt PROMPT_SUBST
PROMPT=$PROMPT'%{$(vterm_prompt_end)%}'


#sidevids helpers
sidevids3() {
    if [ "$#" -lt 3 ]; then
        echo "Usage: sidevids <vid1> <vid2> <vid3> [params to mpv..]"
        return 1
    fi

    local vid1="$1"
    local vid2="$2"
    local vid3="$3"

    mpv --lavfi-complex="[vid1][vid2][vid3]hstack=inputs=3[vo]" "$vid1" --external-files="$vid2:$vid3" "${@:4}"
}

sidevids2() {
    if [ "$#" -lt 2 ]; then
        echo "Usage: sidevids2 <vid1> <vid2> [params to mpv..]"
        return 1
    fi

    local vid1="$1"
    local vid2="$2"

    mpv --lavfi-complex="[vid1][vid2]hstack=inputs=2[vo]" "$vid1" --external-files="$vid2" "${@:3}"
}



# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba init' !!
export MAMBA_EXE='/home/lili/.local/bin/micromamba';
export MAMBA_ROOT_PREFIX='/home/lili/micromamba';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<

alias mamba=micromamba
alias conda=micromamba
