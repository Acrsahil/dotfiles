# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

setopt IGNOREEOF
# Where to store the history file
HISTFILE=~/.zsh_history
# Number of commands to remember
HISTSIZE=10000
# Number of commands saved in the file
SAVEHIST=10000

# Append to the history file instead of overwriting it
setopt APPEND_HISTORY
# Share history across multiple terminal sessions
setopt SHARE_HISTORY
# Save each command to the history file immediately
setopt INC_APPEND_HISTORY


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



alias "ht"="nmcli dev wifi hotspot ifname wlp2s0 ssid StarB password asdfghjkl"
alias ffplay='ffplay -nodisp -autoexit'



# Path to your oh-my-zsh installation.

eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml

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
alias bnvim='bash -c "nvim"'
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
# alias ls='eza -1   --icons=auto' # short list
alias "ls"=lsd
alias ld='eza -lhd --icons=auto' # long list dirs
alias un='$aurhelper -rns' # uninstall package
alias up='$aurhelper -syu' # update system/package/aur
alias pl='$aurhelper -qs' # list installed package
alias pa='$aurhelper -ss' # list availabe package
alias pc='$aurhelper -sc' # remove unused cache
alias po='$aurhelper -qtdq | $aurhelper -rns -' # remove unused packages, also try > $aurhelper -qqd | $aurhelper -rsu --print -
alias vc='code --disable-gpu' # gui code editor

export EDITOR=nvim
export VISUAL=nvim

export LC_ALL=en_US.UTF-8

plugins=(git zsh-autosuggestions)


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PATH="/usr/lib/ruby/gems/3.0.0/bin:$PATH"
source /home/window/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh



[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


export FZF_DEFAULT_OPS="--extended"




export FZF_DEFAULT_COMMAND="fd . --type f  --follow --exclude .git \
                            --exclude node_modules \
                            --exclude /mnt \
                            --exclude /media \
                            --exclude /proc \
                            --exclude /sys \
                            --exclude /var \
                            --exclude /usr \
                            --max-depth 7 \
                            $HOME"


export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview='bat --color=always {}' --height=100% --bind 'shift-up:preview-page-up,shift-down:preview-page-down'"

# 🧠 Command history search with Ctrl+R


# History search (Ctrl+R) like Ctrl+T
export FZF_CTRL_R_OPTS="
  --height=100%
  --layout=reverse
  --border
  --preview='echo {}' 
  --bind 'shift-up:preview-page-up,shift-down:preview-page-down'
"

# Load fzf keybindings (ensure it's installed via your plugin manager or homebrew)
export FZF_CTRL_R_OPTS="--height=100% --layout=reverse --border"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh




source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh


codef() {
    mkdir "$1" && cd "$1" || return
    if touch A.cpp B.cpp C.cpp D.cpp E.cpp; then
        echo "Directory created successfully."
        # Write the code snippet to each file
        for file in A.cpp B.cpp C.cpp D.cpp E.cpp; do

            echo '/* Sahil Acharya */'>> "$file"
            echo '#include <bits/stdc++.h>' >> "$file"
            echo 'using namespace std;' >> "$file"
            echo '' >> "$file"
            echo '#define F(i, n) for (int i = 0; i < n; i++)' >> "$file"
            echo '#define vi vector<int>' >> "$file"
            echo '#define all(v) v.begin(), v.end()' >> "$file"
            echo '#define ln long long int' >> "$file"
            echo '#define test int t; cin >> t; while (t--)' >> "$file"
            echo '#define ll long long' >> "$file"
            echo '#define vi vector<int>' >> "$file"
            echo '#define py cout << "YES" << endl' >> "$file"
            echo '#define pn cout << "NO" << endl' >> "$file"
            echo '#ifndef ONLINE_JUDGE' >> "$file"
            echo '#define debug(x) cerr << #x << " -> "; _print(x); cerr << endl' >> "$file"
            echo '#else' >> "$file"
            echo '#define debug(x)' >> "$file"
            echo '#endif' >> "$file"
            echo '' >> "$file"
            echo 'void _print(int a) { cerr << a << " "; }' >> "$file"
            echo 'void _print(long long a) { cerr << a << " "; }' >> "$file"
            echo 'void _print(char a) { cerr << a << " "; }' >> "$file"
            echo 'void _print(string a) { cerr << a << " "; }' >> "$file"
            echo 'void _print(bool a) { cerr << a << " "; }' >> "$file"
            echo 'template <class T, class V> void _print(pair<T, V> p) { cerr << "{"; _print(p.first); cerr << ","; _print(p.second); cerr << "}"; }' >> "$file"
            echo 'template <class T> void _print(vector<T> v) { cerr << "[ "; for (T i : v) { _print(i); cerr << " "; } cerr << "]"; }' >> "$file"
            echo 'template <class T> void _print(set<T> v) { cerr << "[ "; for (T i : v) { _print(i); cerr << " "; } cerr << "]"; }' >> "$file"
            echo 'template <class T> void _print(multiset<T> v) { cerr << "[ "; for (T i : v) { _print(i); cerr << " "; } cerr << "]"; }' >> "$file"
            echo 'template <class T, class V> void _print(map<T, V> v) { cerr << "[ "; for (auto i : v) { _print(i); cerr << " "; } cerr << "]"; }' >> "$file"
            echo 'template <class T> void _print(pair<T, T> p) { cerr << "{"; _print(p.first); cerr << ","; _print(p.second); cerr << "}"; }' >> "$file"
            echo 'template <class T, class V> void _print(multimap<T, V> v) { cerr << "[ "; for (auto i : v) { _print(i); cerr << " "; } cerr << "]"; }' >> "$file"
            echo 'template <class T> void _print(unordered_set<T> v) { cerr << "[ "; for (T i : v) { _print(i); cerr << " "; } cerr << "]"; }' >> "$file"
            echo 'template <class T> void _print(unordered_multiset<T> v) { cerr << "[ "; for (T i : v) { _print(i); cerr << " "; } cerr << "]"; }' >> "$file"
            echo 'template <class T, class V> void _print(unordered_map<T, V> v) { cerr << "[ "; for (auto i : v) { _print(i); cerr << " "; } cerr << "]"; }' >> "$file"
            echo '' >> "$file"
            echo 'const auto start_time = std::chrono::high_resolution_clock::now();' >> "$file"
            echo '' >> "$file"
            echo 'void sahildas() {' >> "$file"
            echo '    auto end_time = std::chrono::high_resolution_clock::now();' >> "$file"
            echo '    std::chrono::duration<double> diff = end_time - start_time;' >> "$file"
            echo '' >> "$file"
            echo '    cerr << "Time Taken: " << fixed << setprecision(6) << diff.count() << " seconds" << endl;' >> "$file"
            echo '}' >> "$file"
            echo '' >> "$file"


            echo '' >> "$file"
            echo 'void solve(){' >> "$file"
            echo '' >> "$file"
            echo '}' >> "$file"
            echo 'int main() {' >> "$file"
            echo '#ifndef ONLINE_JUDGE' >> "$file"
            echo '    freopen("/home/window/codehub/100_Days_DSA/Competetive_Coding/input.txt","r",stdin);' >> "$file"
            echo '    freopen("/home/window/codehub/100_Days_DSA/Competetive_Coding/output.txt","w",stdout);' >> "$file"
            echo '    freopen("/home/window/codehub/100_Days_DSA/Competetive_Coding/Error.txt", "w", stderr);' >> "$file"
            echo '#endif' >> "$file"
            echo '' >> "$file"
            echo 'test   solve();' >> "$file"
            echo '   sahildas();' >> "$file"
            echo '' >> "$file"
            echo '    return 0;' >> "$file"
            echo '}' >> "$file"
            # Move cursor above the #endif directive
            echo '' >> "$file"
        done
    else
        echo "Failed to create files."
    fi
}




source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh

fzf_open_in_nvim() {
    selected_files=$(fd . --type f --hidden --follow \
                           --exclude .git \
                           --exclude node_modules \
                           --exclude /mnt \
                           --exclude /media \
                           --exclude /proc \
                           --exclude /sys \
                           --exclude /var \
                           --exclude /usr \
                           --max-depth 5 | \
                           fzf -m --preview="bat --style=plain --color=always --line-range=:500 {}")
    if [[ -n "$selected_files" ]]; then
        nvim $selected_files
    fi
    zle reset-prompt
}
zle -N fzf_open_in_nvim
bindkey '^X' fzf_open_in_nvim





zf_find_dir() {
    local selected_dirs=$(fd . --type d --hidden --follow \
                           --exclude .git \
                           --exclude node_modules \
                           --exclude /mnt \
                           --exclude /media \
                           --exclude /proc \
                           --exclude /sys \
                           --exclude /var \
                           --exclude /usr \
                           --max-depth 5 | \
                           fzf -m --preview="tree -C {} | head -n 50")
                               if [[ -n "$selected_dirs" ]]; then
                                 cd "$selected_dirs" && whoami
                                 zle reset-prompt
                               fi
                             }
                             zle -N zf_find_dir
                             bindkey '^D' zf_find_dir

#autoload -U promptinit; promptinit
#prompt pure


export STARSHIP_CACHE=~/.starship/cache
# conda deactivate
export STARSHIP_CACHE=~/.starship/cache
#starship preset no-empty-icons -o ~/.config/starship.toml
ZSH_DEBUG=1



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
conda deactivate

export FUNCNEST=1000
ulimit -s 65532  # Increases the stack size limit
export ZSH_RLIMIT=65532

csv() {
  column -s, -t < "$1" | less -#2 -N -S
}

alias drun="./drun.sh"
alias dcode="./dcode.sh"



export PATH=$PATH:/usr/lib/qt/bin
source /home/window/Auto-Git/alias.sh

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/window/.lmstudio/bin"
echo 'eval "$(zoxide init zsh)"' >> ~/.zshrc

HISTSIZE=1000
SAVEHIST=1000


eval "$(zoxide init zsh)"
eval "$(zoxide init zsh)"
eval "$(zoxide init zsh)"
eval "$(zoxide init zsh)"
eval "$(zoxide init zsh)"
eval "$(zoxide init zsh)"
eval "$(zoxide init zsh)"
eval "$(zoxide init zsh)"
