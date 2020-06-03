function fish_greeting -d "Greeting message on shell session start up"

    echo -en (welcome_message) "\n"
    echo -en (show_date_info) "\n"
    echo -en "\n"
    echo -en (show_disk_info) "\n"
    echo -en (show_net_info) "\n"
    set_color grey
    echo "Have a nice trip"
    echo -en "\n"
    set_color normal
end


function welcome_message -d "Say welcome to user"

    echo -en "Welcome aboard captain "
    set_color FFF  # white
    echo -en (whoami) "!"
    set_color normal
end



function show_date_info -d "Prints information about date"
    set --local up_time (uptime | cut -d "," -f1 | awk -F 'p ' '{print $2}')

    echo -en "Today is "
    set_color cyan
    echo -en (date +%Y.%m.%d)
    set_color normal
    echo -en ", we are up and running for "
    set_color cyan
    echo -en "$up_time"
    set_color normal
    echo -en "."
end


function show_disk_info -d "Prints information about disk"
    set --local disk_info (df -h | awk '/disk1s1/ {print $3 " / "$2}')
    set_color yellow
    echo -en "Disk: "
    set_color 0F0  # green
    echo -en $disk_info
    set_color normal
end


function show_net_info -d "Prints information about network"
    set ip (ifconfig | rg 'inet ' | awk 'NR==2 {print $2}')
    set_color yellow
    echo -en "IP: "
    set_color 0F0  # green
    echo -en "$ip"
    set_color normal
end

