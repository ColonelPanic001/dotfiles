# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd extendedglob
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/mike/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# we like the calculator built into the shell
autoload -U zcalc

export PATH="$PATH:/home/mward/bin"

setopt promptsubst
autoload -U promptinit && promptinit
autoload -U zrecompile

bindkey "jj" vi-cmd-mode

#PROMPT='%~%>:%{\e[0m%}' # default prompt
#RPROMPT='[%* on %W]' # prompt for right side of screen

## Command Aliases
alias c='clear'
alias r='screen -R'
alias ls='ls --color=auto -F'
alias l='ls -lAFh --color=auto'
alias ld='ls -ltr --color=auto'

# Pipe Aliases (Global)
alias -g L='|less'
alias -g G='|grep'
alias -g T='|tail'
alias -g H='|head'
alias -g W='|wc -l'
alias -g S='|sort'

# -----------------------------------------------
# GIT STUFF
# -----------------------------------------------
setopt prompt_subst
autoload colors
colors

autoload -Uz vcs_info
#set some colors
for COLOR in RED GREEN YELLOW WHITE BLACK CYAN; do
    eval PR_$COLOR='%{$fg[${(L)COLOR}]%}'
    eval PR_BRIGHT_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
done


PR_RESET="%{${reset_color}%}";

#
# set formats
# # %b - branchname
# # %u - unstagedstr (see below)
# # %c - stangedstr (see below)
# # %a - action (e.g. rebase-i)
# # %R - repository path
# # %S - path in the repository
FMT_BRANCH="${PR_GREEN}%b%u%c${PR_RESET}" # removed %c for stagedstr e.g. master¹²
FMT_ACTION="(${PR_CYAN}%a${PR_RESET}%)" # e.g. (rebase-i)
FMT_PATH="%R${PR_YELLOW}/%S" # e.g. ~/repo/subdir

# check-for-changes can be really slow.
# you should disable it, if you work with large repositories
# zstyle ':vcs_info:*:prompt:*' check-for-changes true
# zstyle ':vcs_info:*:prompt:*' unstagedstr "¹" # display ¹ if there are unstaged changes
# zstyle ':vcs_info:*:prompt:*' stagedstr "²" # display ² if there are staged changes
#
zstyle ':vcs_info:*:prompt:*' actionformats "${FMT_BRANCH}${FMT_ACTION}//" "${FMT_PATH}"
zstyle ':vcs_info:*:prompt:*' actionformats "${FMT_BRANCH} ${FMT_ACTION}//" "${FMT_PATH}"
zstyle ':vcs_info:*:prompt:*' formats "${FMT_BRANCH}//" "${FMT_PATH}"

zstyle ':vcs_info:*:prompt:*' nvcsformats "" "%~"

function precmd {
    vcs_info 'prompt'
}

# handle vi NORMAL/INSERT mode change
ZLE_VIMODE="#"
ZLE_COLOR="blue"
function zle-line-init zle-keymap-select {
        ZLE_VIMODE="${${KEYMAP/vicmd/N}/(main|viins)/I}"
        ZLE_COLOR="${${KEYMAP/vicmd/red}/(main|viins)/green}"
        zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

function lprompt {
    local brackets=$1
    local color1=$2
    local color2=$3
    local color3=$4
    local color4=$5
                     
    local bracket_open="${color1}${brackets[1]}${PR_RESET}"
    local bracket_close="${color1}${brackets[2]}${PR_RESET}"
    local at="@"
                                                            
    local date="${color2}%D{%T}${PR_RESET}"
    local user_host="${color3}%n${PR_RESET}${at}${color4}%m${PR_RESET}"
    local vcs_cwd='${${vcs_info_msg_1_%%.}/$HOME/~}'
    local cwd="${color4}%B%20<..<${vcs_cwd}%<<%b"

    PROMPT="${PR_RESET}${bracket_open}${date}${bracket_close} ${user_host}%# ${PR_RESET}"
    # PROMPT="${PR_RESET}${bracket_open}${git}${cwd} ${ZLE_COLOR}${vimode}${PR_RESET} ${bracket_close}%# ${PR_RESET}"
}

function rprompt {
    local brackets=$1
    local color1=$2
    local color2=$3
                     
    local bracket_open="${color2}${brackets[1]}${PR_RESET}"
    local bracket_close="${color2}${brackets[2]}"
                                                             
    local vimode='${ZLE_VIMODE}'
    local col3='%{$fg_bold[$ZLE_COLOR]%}'

    local git='$vcs_info_msg_0_'
    local vcs_cwd='${${vcs_info_msg_1_%%.}/$HOME/~}'
    #local cwd="${color2}%B%1~%b"
    local cwd="${color2}%B%20<..<${vcs_cwd}%<<%b"
    RPROMPT="${PR_RESET}${bracket_open}${git}${cwd}${col3}${PR_RESET}${bracket_close}${PR_RESET}"
}

lprompt '[]' $BR_BRIGHT_BLACK $PR_BRIGHT_BLACK $PR_BRIGHT_BLACK $PR_BRIGHT_RED $PR_BRIGHT_GREEN
rprompt '()' $BR_BRIGHT_BLACK $PR_WHITE
