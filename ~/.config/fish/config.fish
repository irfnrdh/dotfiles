if status is-interactive
    # Commands to run in interactive sessions can go here
end

function fish_greeting
    echo " "
    #echo 'just call me: '(set_color blue)'rts,'(set_color cyan)' and I will be there for you <3'
    echo " "
end

function update
    echo "Oke, kita Update system ya ..."
    sudo pacman -Syu
    echo "Updating packages managed by AUR..."
    yay -Syu
    echo "Updating Flatpak packages..."
    flatpak update
    echo "Updating Snap packages..."
    sudo snap refresh
    echo "Update complete!"
end

function c 
  sudo clear
end

function e 
  sudo nvim $argv
end

function sniper
  sudo sn1per $argv
end 

#set -x PATH (go1.17.1 env GOROOT)/bin $PATH

alias ll="exa -l"
alias unmute 'amixer -D pulse sset Master unmute'

# Define a function to toggle mute/unmute
function toggle_mute
    # Check if the Master channel is muted
    if amixer -D pulse sget Master | grep -q '\[off\]'
        # If muted, unmute
        amixer -D pulse sset Master unmute
    else
        # If unmuted, mute
        amixer -D pulse sset Master mute
    end
end

# Create an alias to call the toggle_mute function
alias mute_toggle 'toggle_mute'


#alias sniper= "sn1per"

set -x GOPATH $HOME/go
set -x PATH $PATH $GOPATH/bin
set -x CHROME_EXECUTABLE /usr/bin/google-chrome-stable

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
