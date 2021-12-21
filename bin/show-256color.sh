#!/bin/bash

function set_fg_color() {
    tput setaf $1
}

function set_bg_color() {
    tput setab $1
}

function show_number() {
    printf "%3d " ${color}
}

# 16 color
color=0
while [ ${color} -lt 16 ]; do
    for in in {0..7}; do
        set_fg_color ${color}
        show_number ${color}
        color=$((${color} + 1))
    done
    printf "\n"
done

# colors
while [ ${color} -lt 232 ]; do
    for i in {0..35}; do
        set_fg_color ${color}
        show_number ${color}
        color=$((${color} + 1))
    done
    printf "\n"
done

# gray scale
while [ ${color} -lt 256 ]; do
    set_fg_color ${color}
    show_number ${color}
    color=$((${color} + 1))
done
printf "\n"


#
# background color
#
# 16 color
tput setaf 15
for ((color=0; color<8; color++)); do
    printf "$(tput setab ${color})%3d " ${color}
done
printf "\n"

tput setaf 0
for ((color=8; color<16; color++)); do
    printf "$(tput setab ${color})%3d " ${color}
done
printf "\n"

# colors
while [ ${color} -lt 232 ]; do
    line_head_color=${color}
    for fg_color in 15 0; do
        color=${line_head_color}
        for in in {0..5}; do
            set_fg_color ${fg_color}
            set_bg_color ${color}
            show_number ${color}
            color=$((${color} + 1))
        done
        printf "\n"
    done
done

# gray scale
line_head_color=${color}
for fg_color in 15 0; do
    color=${line_head_color}
    for i in {0..23}; do
        set_fg_color ${fg_color}
        set_bg_color ${color}
        show_number ${color}
        color=$((${color} + 1))
    done
    printf "\n"
done
