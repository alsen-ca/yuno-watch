#!/usr/bin/env bats

setup() {
    DIR="/home/debrian/Downloads/yuno-watch"
}

@test "Directory $DIR exists" {
    run [ -d "$DIR" ]
    [ "$status" -eq 0 ]
}
