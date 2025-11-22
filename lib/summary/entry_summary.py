#!/usr/bin/env python3
from common.reader import file_content
import common.writer as writer
import os, sys
from datetime import datetime, timedelta, timezone

TIMESTAMP = datetime.now().strftime("%Y-%m:%d %H-%M")


class Workflow:
    def __init__(self, dir_output):
        self.dir_output = dir_output

    def workflow_summary(self):
        will_basic_summary = os.environ.get("PERFORM_BASIC_SUMMARY")
        print("Will Basic summary: ", will_basic_summary)
        summary_filename = f"{self.dir_output}/summary.log"
        writer.clean_file(summary_filename)
        writer.write_log(summary_filename, f"Summarizing following file: {file_name}")
        writer.write_log(summary_filename, f"Current time: {TIMESTAMP}")
        writer.write_log(summary_filename, f"Summarizing log from: Nginx\n")

    def workflow_attacks(self):
        will_visual_summary = os.environ.get("PERFORM_VISUAL_SUMMARY")
        print("Will Visual summary: ", will_visual_summary)
        attacks_filename = f"{self.dir_output}/attacks.log"
        writer.clean_file(attacks_filename)
        writer.write_log(attacks_filename, f"Summarizing following file: {file_name}")
        writer.write_log(attacks_filename, f"Current time: {TIMESTAMP}")
        writer.write_log(attacks_filename, f"Summarizing Attack logs: \n")

    def workflow_visual(self):
        will_attack_summary = os.environ.get("PERFORM_ATTACK_SUMMARY")
        print("Will Attack summary: ", will_attack_summary)
        visual_filename = f"{self.dir_output}/visual.log"

def main(file_name: str, dir_output: str):
    print("This is the file to be read: ", file_name)
    print("This is the folder where this file will write the summaries: ", dir_output)
    file = file_content(file_name)
    flow = Workflow(dir_output)
    flow.workflow_summary()
    flow.workflow_attacks()
    flow.workflow_visual()



if __name__ == "__main__":
    file_name = sys.argv[1]
    dir_output = sys.argv[2]
    main(file_name, dir_output)