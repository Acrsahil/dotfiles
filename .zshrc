# ========== History Settings ==========
setopt IGNOREEOF
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

# ========== Vi Mode ==========
set -o vi
[[ -f /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh ]] && \
  source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh

# ========== Prompt ==========
if command -v starship &>/dev/null; then
  export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
  export STARSHIP_CACHE="$HOME/.starship/cache"
  eval "$(starship init zsh)"
fi

# ========== Environment ==========
export EDITOR=nvim
export VISUAL=nvim
export LC_ALL=en_US.UTF-8
export FUNCNEST=100000
ulimit -s 65532
export ZSH_RLIMIT=65532
export PATH="$PATH:/usr/lib/ruby/gems/3.0.0/bin:/usr/lib/qt/bin:$HOME/.lmstudio/bin"

# ========== History Navigation (fzf) ==========
export FZF_DEFAULT_OPS="--extended"
export FZF_DEFAULT_COMMAND="fd . --type f --follow --exclude .git --exclude node_modules --exclude /mnt --exclude /media --exclude /proc --exclude /sys --exclude /var --exclude /usr --max-depth 7 $HOME"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview='bat --color=always {}' --height=100% --bind 'shift-up:preview-page-up,shift-down:preview-page-down'"
export FZF_CTRL_R_OPTS="--height=100% --layout=reverse --border --preview='echo {}' --bind 'shift-up:preview-page-up,shift-down:preview-page-down'"

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# ========== Plugins ==========
[[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

[[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ========== Aliases ==========
alias shutdown='cp "$HOME/hyprlandtoggle/toggle2.conf" "$HOME/.config/hypr/keybindings.conf" && shutdown now'
alias reboot='cp "$HOME/hyprlandtoggle/toggle2.conf" "$HOME/.config/hypr/keybindings.conf" && reboot'
alias ht="nmcli dev wifi hotspot ifname wlp2s0 ssid StarB password asdfghjkl"
alias ffplay='ffplay -nodisp -autoexit'
alias usb='cd ~/run/media/hitler'
alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
alias vi='nvim'
alias nano='nvim'
alias bnvim='bash -c "nvim"'
alias t='tmux'
alias ta='tmux a'
alias r='ranger'
alias data='cd ~/codehub/Data_Science_Project/notebookfile/ && jupyter lab'
alias ip='echo $(ifconfig enp4s0 2>/dev/null | grep "inet " | awk "{print \$2}")'
alias l='eza -lh --icons=auto'
alias ls='lsd'
alias ld='eza -lhd --icons=auto'
alias un='$aurhelper -rns'
alias up='$aurhelper -syu'
alias pl='$aurhelper -qs'
alias pa='$aurhelper -ss'
alias pc='$aurhelper -sc'
alias po='$aurhelper -qtdq | $aurhelper -rns -'
alias vc='code --disable-gpu'
alias gitpush='cd && ./gitpush.sh'
alias drun="./drun.sh"
alias dcode="./dcode.sh"
alias sshaws="cd ~/Downloads && ssh -i \"mykeypair.pem\" ubuntu@ec2-34-224-99-240.compute-1.amazonaws.com"
alias nano="nvim"
alias 'sudo nano'="nvim"
alias till='cd ~/Documents/codehub/Mount_Bill/' 
alias pyserver='till && cd mount_django && python manage.py runserver'


# ========== Terminal Instance Script ==========
TERM_INSTANCE_FILE="/tmp/term_instance_count"
if [[ -f "$TERM_INSTANCE_FILE" ]]; then
    count=$(cat "$TERM_INSTANCE_FILE")
    count=$((count+1))
else
    count=1
fi
echo "$count" > "$TERM_INSTANCE_FILE"
if [[ "$count" -eq 1 && -x "$HOME/hyprlandtoggle/togglescript.sh" ]]; then
    "$HOME/hyprlandtoggle/togglescript.sh"
fi

# ========== AUR Helper Detection ==========
if command -v yay &>/dev/null; then
    aurhelper="yay"
elif command -v paru &>/dev/null; then
    aurhelper="paru"
fi

# ========== Functions ==========
mkcd() {
    mkdir "$1" && cd "$1" || return
    touch A.cpp B.cpp C.cpp D.cpp E.cpp && echo "Files created successfully." || echo "Failed to create files."
}

codef() {
    mkdir "$1" && cd "$1" || return
    for file in A.cpp B.cpp C.cpp D.cpp E.cpp; do
        cat <<EOF > "$file"
/* Sahil Acharya */
#include <bits/stdc++.h>
using namespace std;
int main(){return 0;}
EOF
    done
}

command_not_found_handler() {
    printf 'zsh: command not found: %s\n' "$1"
    return 127
}

in() {
    local pkg="$1"
    if pacman -Si "$pkg" &>/dev/null ; then
        sudo pacman -S "$pkg"
    elif [[ -n "$aurhelper" ]]; then
        "$aurhelper" -S "$pkg"
    fi
}

csv() {
    column -s, -t < "$1" | less -#2 -N -S
}

# ========== FZF Keybinds ==========
fzf_open_in_nvim() {
    selected_files=$(fd . --type f --hidden --follow \
    --exclude .git --exclude node_modules --exclude /mnt \
    --exclude /media --exclude /proc --exclude /sys \
    --exclude /var --exclude /usr --max-depth 5 | \
    fzf -m --preview="bat --style=plain --color=always --line-range=:500 {}")
    [[ -n "$selected_files" ]] && nvim $selected_files
    zle reset-prompt
}
zle -N fzf_open_in_nvim
bindkey '^X' fzf_open_in_nvim

zf_find_dir() {
    selected_dirs=$(fd . --type d --hidden --follow \
    --exclude .git --exclude node_modules --exclude /mnt \
    --exclude /media --exclude /proc --exclude /sys \
    --exclude /var --exclude /usr --max-depth 5 | \
    fzf -m --preview="tree -C {} | head -n 50")
    [[ -n "$selected_dirs" ]] && cd "$selected_dirs" && whoami
    zle reset-prompt
}
zle -N zf_find_dir
bindkey '^D' zf_find_dir

# ========== Conda ==========
if [[ -x "$HOME/anaconda3/bin/conda" ]]; then
    eval "$("$HOME/anaconda3/bin/conda" shell.zsh hook 2>/dev/null)"
    conda deactivate &>/dev/null
fi

# ========== Zoxide ==========
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

# ========== Auto-Git ==========
[[ -f "$HOME/codehub/Auto-Git/alias.sh" ]] && source "$HOME/codehub/Auto-Git/alias.sh"

# ========== Android/Flutter/NVM ==========
export ANDROID_SDK_ROOT=$HOME/Android/Sdk
export ANDROID_HOME=$ANDROID_SDK_ROOT
export PATH=$PATH:$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin
export PATH="$HOME/flutter/bin:$HOME/flutter/bin/cache/dart-sdk/bin:$PATH:$HOME/.pub-cache/bin"

alias runapp='QT_QPA_PLATFORM=xcb LIBGL_ALWAYS_SOFTWARE=1 emulator -avd Pixel_9_Pro_XL -gpu swiftshader_indirect'
alias runpixel='QT_QPA_PLATFORM=xcb LIBGL_ALWAYS_SOFTWARE=1 emulator -avd Pixel_9_Pro_XL -gpu swiftshader_indirect -scale 1.5'
alias runpixel_lite='QT_QPA_PLATFORM=xcb LIBGL_ALWAYS_SOFTWARE=1 emulator -avd Pixel_9_Pro_XL_Lite -gpu swiftshader_indirect -scale 1.5'
alias runmedium='QT_QPA_PLATFORM=xcb LIBGL_ALWAYS_SOFTWARE=1 emulator -avd Medium_Phone -gpu swiftshader_indirect -scale 1.5'

export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"

# ========== Auto Python venv ==========
autoload -U add-zsh-hook


# ========== Auto Python venv ==========
_find_env_dir() {
    local dir="$PWD"
    while [[ "$dir" != "/" ]]; do
        # Check for env/bin/activate
        if [[ -f "$dir/env/bin/activate" ]]; then
            echo "$dir/env"
            return 0
        fi
        # Also check for venv/bin/activate (common alternative)
        if [[ -f "$dir/venv/bin/activate" ]]; then
            echo "$dir/venv"
            return 0
        fi
        dir="$(dirname "$dir")"
    done
    return 1
}

auto_venv_parent() {
    local env_path="$(_find_env_dir)"
    local current_env="$VIRTUAL_ENV"

    # Case 1: Found env and not currently in any venv -> activate
    if [[ -n "$env_path" && -z "$current_env" ]]; then
        source "$env_path/bin/activate"
        echo "🐍 venv ON → $(basename "$env_path")"
        return 0
    fi

    # Case 2: Found env but different from current active one -> switch
    if [[ -n "$env_path" && -n "$current_env" && "$current_env" != "$env_path" ]]; then
        deactivate 2>/dev/null
        source "$env_path/bin/activate"
        echo "🔁 venv SWITCH → $(basename "$env_path")"
        return 0
    fi

    # Case 3: No env found but venv is active -> deactivate
    if [[ -z "$env_path" && -n "$current_env" ]]; then
        deactivate 2>/dev/null
        return 0
    fi

    # Case 4: Already in the correct venv -> do nothing
    if [[ -n "$env_path" && -n "$current_env" && "$current_env" == "$env_path" ]]; then
        return 0
    fi
}

# Hook into directory changes
autoload -U add-zsh-hook
add-zsh-hook chpwd auto_venv_parent

# Run once when shell starts
auto_venv_parent

killallport() {
    ports=(3000 5173 8000 8080 5000)
    for p in "${ports[@]}"; do
        if sudo fuser -k "$p"/tcp 2>/dev/null; then
            echo " Killed port $p"
        fi
    done
}



# add-zsh-hook chpwd 
export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share:$XDG_DATA_DIRS"
source /home/hitler/Auto-Git/alias.sh
