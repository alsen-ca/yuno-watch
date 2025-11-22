#!/usr/bin/env bats

@test "Configuration summary variables gets overwritten for tests" {
    [ "$SUMMARY_SUB" = "$SUMMARY_TEST" ]
}

@test "Configuration rotation variable gets overwritten for tests" {
    [ "$ROTATION_SUB" = "$ROTATION_TEST" ]
}

@test "Configuration success output variable gets overwritten for tests" {
    [ "$SUCCESS_OUTPUT" = "${LOG_OUTPUT}/test.success.log" ]
}

@test "Configuration error output variable gets overwritten for tests" {
    [ "$ERROR_OUTPUT" = "${LOG_OUTPUT}/test.error.log" ]
}

@test "Configuration nginx output variable gets overwritten for tests" {
    [ "$NGINX_LOGS" = "${LOG_OUTPUT}" ]
}