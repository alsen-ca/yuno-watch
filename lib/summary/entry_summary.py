#!/usr/bin/env python3
from utils.reader import file_content
import utils.writer as writer
from summaries import get_summarizer_class
import utils.writer as writer

import os, sys, re
from datetime import datetime, timedelta, timezone

TIMESTAMP = datetime.now().strftime("%Y-%m-%d %H:%M")
sum_dir = os.environ.get("LIB_DIR")
sum_dir = f"{sum_dir}/summary"

def load_regex_pattern():
    log_format = os.environ.get("NGINX_LOG_FORMAT")
    pattern_file = f"{sum_dir}/log_regex/{log_format}.txt"
    with open(pattern_file, "r") as f:
        pattern = f.read().strip()
    return re.compile(pattern, re.VERBOSE)

def load_attack_pattern():
    """Load the regex pattern for detecting attacks."""
    attack_pattern_file = f"{sum_dir}/log_regex/attack.txt"
    with open(attack_pattern_file, "r") as f:
        attack_pattern = f.read().strip()
    return re.compile(attack_pattern, re.VERBOSE)


def main(file_name: str, dir_output: str):
    print("This is the folder where this file will write the summaries: ", dir_output)
    lines = file_content(file_name)
    pattern = load_regex_pattern()
    writer.clean_file(f"{dir_output}/summary.log")
    writer.clean_file(f"{dir_output}/attacks.log")
    attack_pattern = load_attack_pattern()
    SummarizerClass = get_summarizer_class()
    sum = SummarizerClass(lines, pattern, attack_pattern)
    summary = sum.summarize()
    printable_summary = sum.print_dic(summary)
    writer.write_log(f"{dir_output}/summary.log", printable_summary)





if __name__ == "__main__":
    file_name = sys.argv[1]
    dir_output = sys.argv[2]
    main(file_name, dir_output)