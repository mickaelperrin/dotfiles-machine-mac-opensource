#!/usr/bin/env bash

dstop() { ask "STOP all Docker containers" && docker stop $(docker ps -a -q); } # Stop all containers
drmall() { ask "REMOVE all Docker containers" && docker rm $(docker ps -a -q); } # Remove all containers
alias drmf='ask "STOP & REMOVE all Docker containers" && docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)' # Stop and Remove all containers
driall() { ask "REMOVE all Docker images" && docker rmi $(docker images -q); } # Remove all images
dclean() { docker volume ls -qf dangling=true | xargs docker volume rm }
dalias() { alias | grep 'docker' | sed "s/^\([^=]*\)=\(.*\)/\1 => \2/"| sed "s/['|\']//g" | sort; } # Show all alias related docker
