#!/usr/bin/env python3
import utils.reader as reader
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
    attack_pattern_file = f"{sum_dir}/log_regex/attacks.txt"
    with open(attack_pattern_file, "r") as f:
        attack_pattern = f.read().strip()
    return re.compile(attack_pattern, re.VERBOSE)


def main(file_name: str, dir_output: str):
    print("This is the folder where this file will write the summaries: ", dir_output)
    will_basic_summary = os.environ.get("PERFORM_BASIC_SUMMARY", "").lower() == "true"
    will_visual_summary = os.environ.get("PERFORM_VISUAL_SUMMARY", "").lower() == "true"
    uses_docker = os.environ.get("USES_DOCKER", "").lower() == "true"

    if will_basic_summary:
        lines = reader.file_content(file_name)
        pattern = load_regex_pattern()
        writer.clean_file(f"{dir_output}/summary.log")
        writer.clean_file(f"{dir_output}/attacks.log")
        attack_pattern = load_attack_pattern()

        SummarizerClass = get_summarizer_class()
        sum = SummarizerClass(lines, pattern, attack_pattern, dir_output)
        summary = sum.summarize()
        writer.save_summary_data(dir_output, file_name, summary, sum.total_unique_ips())

        data_summary = reader.load_data_from_json(dir_output, "summary")
        printable_summary = sum.print_dic(data_summary)
        data_date = reader.load_data_from_json(dir_output, "date")
        data_total_ips = reader.load_data_from_json(dir_output, "total_unique_ips")
        printable_total_ips = str(data_total_ips)
        writer.write_log(f"{dir_output}/summary.log", f"Date of summary: {data_date}")
        writer.write_log(f"{dir_output}/summary.log", f"\nTotal amount of unique IPs: {printable_total_ips}\n\n\n")
        writer.write_log(f"{dir_output}/summary.log", f"\nPrinting Unique Users per 15-minute buckets: \n\n{printable_summary}\n")

        writer.write_log(f"{dir_output}/summary.log", f"\nMost visited paths: \n\n{sum.get_status_path_freq()}")
        paths_4xx = sum.get_4xx_paths()
        writer.write_log(f"{dir_output}/4xx.log", paths_4xx)
        paths_2xx = sum.get_2xx_paths()
        writer.write_log(f"{dir_output}/2xx.log", paths_2xx)
    else:
        print("No Basic Summary will happen")
    
    if will_visual_summary and not uses_docker:
        from visual.visual_default import VisualDefault
        from visual.visual_req import VisualWithRequest

        data_summary = reader.load_data_from_json(dir_output, "summary")
        data_date = reader.load_data_from_json(dir_output, "date")
        data_ips = reader.load_data_from_json(dir_output, "total_unique_ips")
        date_obj = datetime.strptime(data_date, "%d.%m.%Y")
        previous_day = date_obj - timedelta(days=1)
        previous_day_str = previous_day.strftime("%d.%m.%Y")
        if os.environ.get("NGINX_LOG_FORMAT") == "default":
            visual_summary = VisualDefault(previous_day_str, data_ips, data_summary).render()
        elif os.environ.get("NGINX_LOG_FORMAT") == "req":
            visual_summary = VisualWithRequest(data_summary).render()
        writer.write_bytes(dir_output, visual_summary)
    else:
        print("No Visual Summary will happen") 
    






if __name__ == "__main__":
    file_name = sys.argv[1]
    dir_output = sys.argv[2]
    main(file_name, dir_output)