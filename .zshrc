# Path to your oh-my-zsh installation.
export ZSH=/home/pierre/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
if [ -n "$INSIDE_EMACS" ]; then
    export ZSH_THEME="fishy-emacs"
else
    export ZSH_THEME="fishy-custom"
fi


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
plugins=(git colored-man-pages z pass nix-shell)
# if [ -z "$INSIDE_EMACS" ]; then
plugins+=zsh-autosuggestions
# fi


# User configuration

export BROWSER=firefox

export PATH=/home/pierre/bin:$PATH
export PATH=/home/pierre/.local/bin:$PATH

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export TERM=xterm-256color

export SHELL=$(which zsh)

if [ -n "$INSIDE_EMACS" ]; then
    ## this setups the path properly
    export TERM="eterm-color"
    chpwd() { print -P "\033AnSiTc %d" }
    print -P "\033AnSiTu %n"
    print -P "\033AnSiTc %d"
    unsetopt PROMPT_SP
fi

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

source $ZSH/oh-my-zsh.sh

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
# alias kobo="k2pdfopt -ui- -h 1827 -w 1404 -dpi 300 -fc-"
alias kobo="k2pdfopt -ui- -h 1727 -w 1304 -dpi 300 -fc- -x" # use smaller width for margin
alias open="xdg-open"
alias ot="xdg-open . &"

alias sa="source activate"

source ~/.oh-my-zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh  


local HAPPY_WORDS="/home/pierre/Dropbox/lists/happy_articles.txt"
local HAPPY_FACES="/home/pierre/Dropbox/lists/happy_emoticons.txt"

function greet() {
    printf "Welcome to $fg_bold[blue]zsh$reset_color.\nHave $fg_bold[green]%s$reset_color day! %s\n" \
           "$(shuf $HAPPY_WORDS | head -1)" "$(shuf $HAPPY_FACES | head -1)"
}


function conda-shell {
    command nix-shell ~/dotfiles/nixos/conda-shell.nix
}

# function greet() {
#     printf "Welcome to $fg_bold[blue]zsh$reset_color.\n"
# }

if [[ $SHLVL -eq 3 ]] ; then
    echo
    # printf "Welcome to $fg_bold[blue]zsh$reset_color.\nHave $fg_bold[green]%s$reset_color day! %s\n" \
        #        "$(shuf $HAPPY_WORDS | head -1)" "$(shuf $HAPPY_FACES | head -1)"
    greet
    echo
fi
