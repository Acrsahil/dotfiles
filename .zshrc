# ========== History Settings ==========
setopt IGNOREEOF
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# ========== Vi Mode ==========
set -o vi
source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh

# ========== Prompt ==========
ZSH_THEME="powerlevel10k/powerlevel10k"
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml
export STARSHIP_CACHE=~/.starship/cache

# ========== Environment ==========
export EDITOR=nvim
export VISUAL=nvim
export LC_ALL=en_US.UTF-8
export FUNCNEST=1000
ulimit -s 65532
export ZSH_RLIMIT=65532
export PATH="$PATH:/usr/lib/ruby/gems/3.0.0/bin:/usr/lib/qt/bin:/home/window/.lmstudio/bin"

# ========== History Navigation (fzf) ==========
export FZF_DEFAULT_OPS="--extended"
export FZF_DEFAULT_COMMAND="fd . --type f  --follow --exclude .git --exclude node_modules --exclude /mnt --exclude /media --exclude /proc --exclude /sys --exclude /var --exclude /usr --max-depth 7 $HOME"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview='bat --color=always {}' --height=100% --bind 'shift-up:preview-page-up,shift-down:preview-page-down'"
export FZF_CTRL_R_OPTS="--height=100% --layout=reverse --border --preview='echo {}' --bind 'shift-up:preview-page-up,shift-down:preview-page-down'"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ========== Plugins ==========
plugins=(git zsh-autosuggestions)
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source /home/window/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ========== Aliases ==========
alias shutdown='cp /home/window/hyprlandtoggle/toggle2.conf /home/window/.config/hypr/keybindings.conf && shutdown now'
alias reboot='cp /home/window/hyprlandtoggle/toggle2.conf /home/window/.config/hypr/keybindings.conf && reboot'
alias draw='/home/window/./open_excalidraw.sh'
alias ht="nmcli dev wifi hotspot ifname wlp2s0 ssid StarB password asdfghjkl"
alias ffplay='ffplay -nodisp -autoexit'
alias usb='cd ~/run/media/window'
alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
alias vi='nvim'
alias nano='nvim'
alias bnvim='bash -c "nvim"'
alias t='tmux'
alias ta='tmux a'
alias cppp='tmux select-window -t 1'
alias cpp='tmux a -t First && cppp'
alias maths='tmux select-window -t 5'
alias math='tmux a -t First && maths'
alias bt='cd CODE-HUB/100_Days_DSA/DSA-CODE-Bit/'
alias bit='bt && nvim'
alias pyy='tmux select-window -t 2'
alias py='tmux a -t First && pyy'
alias LD='tmux select-window -t 3'
alias ll='tmux a -t First && LD'
alias WD='tmux select-window -t 0'
alias html='tmux a -t First && WD'
alias r='ranger'
alias data='cd ~/codehub/Data_Science_Project/notebookfile/ && jupyter lab'
alias ip='echo $(ifconfig enp4s0 | grep "inet " | awk "{print \$2}")'
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

# ========== Terminal Instance Script ==========
TERM_INSTANCE_FILE="/tmp/term_instance_count"
if [ ! -f "$TERM_INSTANCE_FILE" ]; then
    echo 1 > "$TERM_INSTANCE_FILE"
else
    count=$(cat "$TERM_INSTANCE_FILE")
    count=$((count+1))
    echo $count > "$TERM_INSTANCE_FILE"
    if [ "$count" -eq 2 ]; then
        /home/window/hyprlandtoggle/./togglescript.sh
    fi
fi

# ========== AUR Helper Detection ==========
if pacman -Qi yay &>/dev/null ; then
   aurhelper="yay"
elif pacman -Qi paru &>/dev/null ; then
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

#define F(i, n) for (int i = 0; i < n; i++)
#define vi vector<int>
#define all(v) v.begin(), v.end()
#define ln long long int
#define test int t; cin >> t; while (t--)
#define ll long long
#define py cout << "YES" << endl
#define pn cout << "NO" << endl
#ifndef ONLINE_JUDGE
#define debug(x) cerr << #x << " -> "; _print(x); cerr << endl
#else
#define debug(x)
#endif

void _print(int a) { cerr << a << " "; }
// more _print overloads...

const auto start_time = std::chrono::high_resolution_clock::now();

void sahildas() {
    auto end_time = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double> diff = end_time - start_time;
    cerr << "Time Taken: " << fixed << setprecision(6) << diff.count() << " seconds" << endl;
}

void solve(){

}
int main() {
#ifndef ONLINE_JUDGE
    freopen("/home/window/codehub/100_Days_DSA/Competetive_Coding/input.txt","r",stdin);
    freopen("/home/window/codehub/100_Days_DSA/Competetive_Coding/output.txt","w",stdout);
    freopen("/home/window/codehub/100_Days_DSA/Competetive_Coding/Error.txt", "w", stderr);
#endif

    test solve();
    sahildas();
    return 0;
}
EOF
    done
}

command_not_found_handler() {
    printf 'zsh: command not found: %s\n' "$1"
    local entries=( ${(f)"$(/usr/bin/pacman -F --machinereadable -- "/usr/bin/$1")"} )
    if (( ${#entries[@]} )) ; then
        printf "$1 may be found in the following packages:\n"
        local pkg
        for entry in "${entries[@]}"; do
            local fields=( ${(0)entry} )
            if [[ "$pkg" != "${fields[2]}" ]] ; then
                printf "%s/%s %s\n" "${fields[1]}" "${fields[2]}" "${fields[3]}"
            fi
            printf '    /%s\n' "${fields[4]}"
            pkg="${fields[2]}"
        done
    fi
    return 127
}

in() {
    local pkg="$1"
    if pacman -Si "$pkg" &>/dev/null ; then
        sudo pacman -S "$pkg"
    else
        "$aurhelper" -S "$pkg"
    fi
}

csv() {
  column -s, -t < "$1" | less -#2 -N -S
}

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
    local selected_dirs=$(fd . --type d --hidden --follow \
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
__conda_setup="$('/home/window/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
elif [ -f "/home/window/anaconda3/etc/profile.d/conda.sh" ]; then
     "/home/window/anaconda3/etc/profile.d/conda.sh"
else
    export PATH="/home/window/anaconda3/bin:$PATH"
fi
unset __conda_setup
conda deactivate

# Load zoxide
eval "$(zoxide init zsh)"


source /home/window/Auto-Git/alias.sh
