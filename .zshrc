# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

 #If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Function to create a new folder and add A.cpp to E.cpp files inside i




# Define the file to keep track of terminal instances


TERM_INSTANCE_FILE="/tmp/term_instance_count"

# Create the file if it doesn't exist, and initialize the count
if [ ! -f "$TERM_INSTANCE_FILE" ]; then
    echo 1 > "$TERM_INSTANCE_FILE"
else
    # Read the current count
    count=$(cat "$TERM_INSTANCE_FILE")
    count=$((count+1)) # Increment count
    echo $count > "$TERM_INSTANCE_FILE" # Save updated count

    # Run the script if it's the second terminal instance
    if [ "$count" -eq 2 ]; then
        /home/window/hyprlandtoggle/./togglescript.sh
    fi
fi


mkcd() {
    mkdir "$1" && cd "$1" || return
    if touch A.cpp B.cpp C.cpp D.cpp E.cpp; then
        echo "Files created successfully."
    else
        echo "Failed to create files."
    fi
}
alias "shutdown"='cp /home/window/hyprlandtoggle/toggle2.conf /home/window/.config/hypr/keybindings.conf && shutdown now'
alias "reboot"='cp /home/window/hyprlandtoggle/toggle2.conf /home/window/.config/hypr/keybindings.conf && reboot'
alias "draw"='/home/window/./open_excalidraw.sh'

alias ffplay='ffplay -nodisp -autoexit'


alias ff='nvim $(fzf -m --preview="bat --color=always {}")'

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Function to create a new folder and add A.cpp to E.cpp files inside it
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"
set -o vi
# In case a command is not found, try to find the package that has it
function command_not_found_handler {
    local purple='\e[1;35m' bright='\e[0;1m' green='\e[1;32m' reset='\e[0m'
    printf 'zsh: command not found: %s\n' "$1"
    local entries=( ${(f)"$(/usr/bin/pacman -F --machinereadable -- "/usr/bin/$1")"} )
    if (( ${#entries[@]} )) ; then
        printf "${bright}$1${reset} may be found in the following packages:\n"
        local pkg
        for entry in "${entries[@]}" ; do
            local fields=( ${(0)entry} )
            if [[ "$pkg" != "${fields[2]}" ]] ; then
                printf "${purple}%s/${bright}%s ${green}%s${reset}\n" "${fields[1]}" "${fields[2]}" "${fields[3]}"
            fi
            printf '    /%s\n' "${fields[4]}"
            pkg="${fields[2]}"
        done
    fi
    return 127
}

# Detect the AUR wrapper
if pacman -Qi yay &>/dev/null ; then
   aurhelper="yay"
elif pacman -Qi paru &>/dev/null ; then
   aurhelper="paru"
fi

function in {
    local pkg="$1"
    if pacman -Si "$pkg" &>/dev/null ; then
        sudo pacman -S "$pkg"
    else
        "$aurhelper" -S "$pkg"
    fi
}



#tmux alias
alias usb='cd ~/run/media/window'

alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'

alias vi='nvim'


alias gitpush='cd && ./gitpush.sh'
alias t='tmux'
alias ta='tmux a'
alias nano='nvim'
#Nagivation aliases
# alias cppp='cd CODE-HUB/100_Days_DSA/Competetive_Coding/'
alias cppp='tmux select-window -t 1'
alias cpp='tmux a -t First && cppp'

# alias maths='cd CODE-HUB/100_Days_DSA/Math_Question/'
alias maths='tmux select-window -t 5'
# alias math='maths && nvim'
alias math='tmux a -t First && maths'

alias bt='cd CODE-HUB/100_Days_DSA/DSA-CODE-Bit/'
alias bit='bt && nvim'

# alias pyy='cd CODE-HUB/Python_Programming/'
alias pyy='tmux select-window -t 2'
# alias py='pyy && nvim'
alias py='tmux a -t First && pyy'

# alias LD='cd CODE-HUB/100_Days_DSA/LinkList/'
alias LD='tmux select-window -t 3'
# alias ll='LD && nvim'
alias ll='tmux a -t First && LD'

# alias WD='cd CODE-HUB/Web-development'
alias WD='tmux select-window -t 0'
# alias html='WD && nvim'
alias html='tmux a -t First && WD'
alias r='ranger'

alias data='cd ~/codehub/Data_Science_Project/notebookfile/ && jupyter lab'


alias ip='echo $(ifconfig enp4s0 | grep "inet " | awk "{print \$2}")'


# helpful aliases
alias  l='eza -lh  --icons=auto' # long list
alias ls='eza -1   --icons=auto' # short list
alias ld='eza -lhd --icons=auto' # long list dirs
alias un='$aurhelper -rns' # uninstall package
alias up='$aurhelper -syu' # update system/package/aur
alias pl='$aurhelper -qs' # list installed package
alias pa='$aurhelper -ss' # list availabe package
alias pc='$aurhelper -sc' # remove unused cache
alias po='$aurhelper -qtdq | $aurhelper -rns -' # remove unused packages, also try > $aurhelper -qqd | $aurhelper -rsu --print -
alias vc='code --disable-gpu' # gui code editor


# to customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#display pokemon
#pokemon-colorscripts --no-title -r 1,3,6

  # Created by `pipx` on 2024-01-15 09:23:36
export EDITOR=nvim
export VISUAL=nvim

# lf icons
# export LF_ICONS="\
# tw=:\
# st=:\
# ow=:\
# dt=:\
# di=:\
# fi=:\
# ln=:\
# or=:\
# ex=:\
# *.c=:\
# *.cc=:\
# *.clj=:\
# *.coffee=:\
# *.cpp=:\
# *.css=:\
# *.d=:\
# *.dart=:\
# *.erl=:\
# *.exs=:\
# *.fs=:\
# *.go=:\
# *.h=:\
# *.hh=:\
# *.hpp=:\
# *.hs=:\
# *.html=:\
# *.java=:\
# *.jl=:\
# *.js=:\
# *.json=:\
# *.lua=:\
# *.md=:\
# *.php=:\
# *.pl=:\
# *.pro=:\
# *.py=:\
# *.rb=:\
# *.rs=:\
# *.scala=:\
# *.ts=:\
# *.vim=:\
# *.cmd=:\
# *.ps1=:\
# *.sh=:\
# *.bash=:\
# *.zsh=:\
# *.fish=:\
# *.tar=:\
# *.tgz=:\
# *.arc=:\
# *.arj=:\
# *.taz=:\
# *.lha=:\
# *.lz4=:\
# *.lzh=:\
# *.lzma=:\
# *.tlz=:\
# *.txz=:\
# *.tzo=:\
# *.t7z=:\
# *.zip=:\
# *.z=:\
# *.dz=:\
# *.gz=:\
# *.lrz=:\
# *.lz=:\
# *.lzo=:\
# *.xz=:\
# *.zst=:\
# *.tzst=:\
# *.bz2=:\
# *.bz=:\
# *.tbz=:\
# *.tbz2=:\
# *.tz=:\
# *.deb=:\
# *.rpm=:\
# *.jar=:\
# *.war=:\
# *.ear=:\
# *.sar=:\
# *.rar=:\
# *.alz=:\
# *.ace=:\
# *.zoo=:\
# *.cpio=:\
# *.7z=:\
# *.rz=:\
# *.cab=:\
# *.wim=:\
# *.swm=:\
# *.dwm=:\
# *.esd=:\
# *.jpg=:\
# *.jpeg=:\
# *.mjpg=:\
# *.mjpeg=:\
# *.gif=:\
# *.bmp=:\
# *.pbm=:\
# *.pgm=:\
# *.ppm=:\
# *.tga=:\
# *.xbm=:\
# *.xpm=:\
# *.tif=:\
# *.tiff=:\
# *.png=:\
# *.svg=:\
# *.svgz=:\
# *.mng=:\
# *.pcx=:\
# *.mov=:\
# *.mpg=:\
# *.mpeg=:\
# *.m2v=:\
# *.mkv=:\
# *.webm=:\
# *.ogm=:\
# *.mp4=:\
# *.m4v=:\
# *.mp4v=:\
# *.vob=:\
# *.qt=:\
# *.nuv=:\
# *.wmv=:\
# *.asf=:\
# *.rm=:\
# *.rmvb=:\
# *.flc=:\
# *.avi=:\
# *.fli=:\
# *.flv=:\
# *.gl=:\
# *.dl=:\
# *.xcf=:\
# *.xwd=:\
# *.yuv=:\
# *.cgm=:\
# *.emf=:\
# *.ogv=:\
# *.ogx=:\
# *.aac=:\
# *.au=:\
# *.flac=:\
# *.m4a=:\
# *.mid=:\
# *.midi=:\
# *.mka=:\
# *.mp3=:\
# *.mpc=:\
# *.ogg=:\
# *.ra=:\
# *.wav=:\
# *.oga=:\
# *.opus=:\
# *.spx=:\
# *.xspf=:\
# *.pdf=:\
# *.nix=:\
# "
export LC_ALL=en_US.UTF-8
export EDITOR=nvim
alias edx="./eDEX-UI.Linux.x86_64.AppImage"

plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PATH="/usr/lib/ruby/gems/3.0.0/bin:$PATH"
source /home/window/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/window/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/window/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/window/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/window/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

alias "ls"=lsd

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh




export FZF_DEFAULT_OPS="--extended"
#export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git --exclude node_modules --max-depth 6"




export FZF_DEFAULT_COMMAND="fd . --type f --hidden --follow --exclude .git \
                            --exclude node_modules \
                            --exclude /mnt \
                            --exclude /media \
                            --exclude /proc \
                            --exclude /sys \
                            --exclude /var \
                            --exclude /usr \
                            --max-depth 5 \
                            $HOME"


export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
#export FZF_CTRL_T_OPTS="--preview=bat --color=always 'less {}' --bind shift-up:preview-page-up,shift-down:preview-page-down"
export FZF_CTRL_T_OPTS="--preview='bat --color=always {}' --height=100% --bind 'shift-up:preview-page-up,shift-down:preview-page-down'"




