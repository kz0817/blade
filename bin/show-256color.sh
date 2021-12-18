#!/bin/bash

# 16 color
color=0
while [ ${color} -lt 16 ]; do
    for ((i=0; i<8; i++)); do
        printf "$(tput setaf ${color})%3d " ${color}
        color=$((${color} + 1))
    done
    printf "\n"
done

# colors
while [ ${color} -lt 232 ]; do
    for ((i=0; i<18; i++)); do
        printf "$(tput setaf ${color})%3d " ${color}
        color=$((${color} + 1))
    done
    printf "\n"
done

# gray scale
while [ ${color} -lt 256 ]; do
    printf "$(tput setaf ${color})%3d " ${color}
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
tput setaf 15
while [ ${color} -lt 232 ]; do
    for ((i=0; i<18; i++)); do
        printf "$(tput setab ${color})%3d " ${color}
        color=$((${color} + 1))
    done
    printf "\n"
done

color=16
tput setaf 0
while [ ${color} -lt 232 ]; do
    for ((i=0; i<18; i++)); do
        printf "$(tput setab ${color})%3d " ${color}
        color=$((${color} + 1))
    done
    printf "\n"
done

# gray scale
tput setaf 15
while [ ${color} -lt 244 ]; do
      printf "$(tput setab ${color})%3d " ${color}
      color=$((${color} + 1))
done
printf "\n"

tput setaf 0
while [ ${color} -lt 256 ]; do
      printf "$(tput setab ${color})%3d " ${color}
      color=$((${color} + 1))
done
printf "\n"
