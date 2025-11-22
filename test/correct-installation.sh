#!/bin/bash

/usr/local/bin/bats --pretty "$TESTS/setup/paths_test.bats"
/usr/local/bin/bats --pretty "$TESTS/setup/tests_outdir_test.bats"
/usr/local/bin/bats --pretty "$TESTS/setup/overwritten_conf_test.bats"