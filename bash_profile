[[ -f ~/.bashrc ]] && . ~/.bashrc
[[ -d ~/.local/bin ]] && PATH="$HOME/.local/bin:${PATH}"
[[ -d ~/dotfiles/bin ]] && PATH="$HOME/dotfiles/bin:${PATH}"
[[ -d ~/fff ]] && PATH="${PATH}:$HOME/fff"
[[ -d ~/pacwall ]] && PATH="${PATH}:$HOME/pacwall"
