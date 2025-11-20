#!/usr/bin/env bats

setup() {
    USERNAME="debrian"
}

@test "User $USERNAME exists" {
    run id "$USERNAME"
    [ "$status" -eq 0 ]
}

@test "User $USERNAME has sudo rights" {
    run sudo -l -U debrian 2>&1
    [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
    [[ "$output" == *"(ALL) ALL"* ]]
}
