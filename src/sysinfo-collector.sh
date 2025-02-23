#!/bin/bash

# Ensure gum is installed
if ! command -v gum &> /dev/null; then
    echo "gum is not installed. Please install it first."
    exit 1
fi

# Display a title using gum
clear
gum style --border double --margin "1" --padding "1" --border-foreground 212 "System Information Collector"

# Define executable names
CMD_FREE="free"
CMD_MPSTAT="mpstat"
CMD_PS="ps"
CMD_LSCPU="lscpu"
CMD_DF="df"
CMD_LSBLK="lsblk"
CMD_UPTIME="uptime"
CMD_UNAME="uname"
CMD_IP="ip"

# Function to check command availability and return a warning message
check_command() {
    local cmd=$1
    local step=$2
    if ! command -v "$cmd" &> /dev/null; then
        echo -e "\nScript uses \`$cmd\` to collect data, please install to use $step option.\n"
        return 1
    fi
    return 0
}

while true; do
    # Prompt user to select what data to collect with improved UI
    options=(\
    "RAM Usage" \
    "CPU Usage" \
    "Running Processes" \
    "CPU Model" \
    "Free Disk Space" \
    "Block Devices List" \
    "System Uptime" \
    "Kernel Version" \
    "Network Devices" \
    "Default Routing Table" \
    "Exit")
    data_to_collect=$(gum choose --height "${#options[@]}" --no-limit --cursor.foreground=3 --selected.foreground=2 "${options[@]}")

    # Convert selected options into an array
    selections=()
    IFS=$'\n' read -d '' -r -a selections <<< "$data_to_collect"

    # If only Exit is selected, exit immediately
    if [[ " ${selections[@]} " =~ " Exit " ]] && [ ${#selections[@]} -eq 1 ]; then
        gum style --foreground 1 "Exiting..."
        exit 0
    fi

    # If Exit is selected with other options, ask user if they want to exit after execution
    if [[ " ${selections[@]} " =~ " Exit " ]] \
    && ! gum confirm "You selected Exit. The program will finish execution after data collection. Do you want to continue with this behavior?"; then
            selections=( "${selections[@]/'Exit'}" )
    fi

    # If no selection is made, exit
    while [ ${#selections[@]} -eq 0 ]; do
        gum confirm "No option selected. Exit?" && gum style --foreground 1 "Exiting..." && exit 0
        data_to_collect=$(gum choose --height "${#options[@]}" --no-limit --cursor.foreground=3 --selected.foreground=2 "${options[@]}")
        IFS=$'\n' read -d '' -r -a selections <<< "$data_to_collect"
    done

    # Display loading animation
    gum spin --spinner dot --title "Collecting system information..." -- sleep 2

    # Generate filename
    script_name=$(basename "$0" .sh)
    hostname=$(hostname)
    date_time=$(date "+%Y-%m-%d_%H-%M-%S")
    output_file="${script_name}-${hostname}-${date_time}.out"

    # Collect and display the selected data with styling
    output=""
    for selection in "${selections[@]}"; do
        case "$selection" in
            "RAM Usage")
                check_command "$CMD_FREE" "RAM Usage" && output+="\nRAM Usage:\n$($CMD_FREE -h)\n"
                ;;
            "CPU Usage")
                check_command "$CMD_MPSTAT" "CPU Usage" && output+="\nCPU Usage:\n$($CMD_MPSTAT 1 1 | awk '/Average:/ {print "CPU Load: " 100 - $NF "%"}')\n"
                ;;
            "Running Processes")
                check_command "$CMD_PS" "Running Processes" && output+="\nRunning Processes (Top 10 by CPU usage):\n$($CMD_PS aux --sort -pcpu | head -n 11)\n"
                ;;
            "CPU Model")
                check_command "$CMD_LSCPU" "CPU Model" && output+="\nCPU Model:\n$($CMD_LSCPU -e=MODELNAME | grep -v MODELNAME)\n"
                ;;
            "Free Disk Space")
                check_command "$CMD_DF" "Free Disk Space" && output+="\nFree Disk Space:\n$($CMD_DF -h)\n"
                ;;
            "Block Devices List")
                check_command "$CMD_LSBLK" "Block Devices List" && output+="\nBlock Devices List:\n$($CMD_LSBLK)\n"
                ;;
            "System Uptime")
                check_command "$CMD_UPTIME" "System Uptime" && output+="\nSystem Uptime:\n$($CMD_UPTIME -p)\n"
                ;;
            "Kernel Version")
                check_command "$CMD_UNAME" "Kernel Version" && output+="\nKernel Version:\n$($CMD_UNAME -r)\n"
                ;;
            "Network Devices")
                check_command "$CMD_IP" "Network Devices" && output+="\nNetwork Devices:\n$($CMD_IP a)\n"
                ;;
            "Default Routing Table")
                check_command "$CMD_IP" "Default Routing Table" && output+="\nDefault Routing Table:\n$($CMD_IP route list)\n"
                ;;
        esac
    done

    echo -e "$output" | gum format
    echo "Data collection complete." | gum style --foreground 2

    # Ask user if they want to save the output
    gum confirm "Do you want to save the output to a file?" && echo -e "$output" > "${HOME}/${output_file}" && gum style --foreground 2 "Data saved to ${HOME}/${output_file}"
    
    # Exit if user confirmed Exit behavior
    [[ " ${selections[@]} " =~ " Exit " ]] && exit 0

    # Ask user if they want to exit or collect more data
    gum confirm "Would you like to collect more data?" || { gum style --foreground 1 "Exiting..."; exit 0; }
done
