#!/bin/bash

/usr/local/bin/bats --pretty "$TESTS/perform/new_month_test.bats"
/usr/local/bin/bats --pretty "$TESTS/perform/rotator_test.bats"
/usr/local/bin/bats --pretty "$TESTS/perform/import_test.bats"
