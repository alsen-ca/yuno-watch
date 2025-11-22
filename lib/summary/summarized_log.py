#!/usr/bin/env python3
# summarized_log.py
# -------------------
# Read nginx logs, make multiple summaries and print them on a file each.
# Summaries are:
#
#   1. Just a general log accumullator
#   2. Potential attacks done via nginx
#   3. Summary of image as .png
#
# Version: 1.0  (2025‑11‑18)

import os
import re
import sys
from collections import defaultdict
from statistics import mean
from datetime import datetime, timedelta, timezone
import matplotlib.pyplot as plt
from visual.visual_default import VisualDefault

year_month=datetime.today().strftime('%Y-%m')
yesterday_day_only=(datetime.today() - timedelta(days=DAYS_BACK)).strftime('%d')
PATH_IN = f"/{year_month}/{yesterday_day_only}"
PATH_OUT = f"/{year_month}/{yesterday_day_only}"

REQ_PATTERN = re.compile(
    r'''
    ''',
    re.VERBOSE,
)

DEFAULT_PATTERN = re.compile(
    r'''
    ''',
    re.VERBOSE,
)

ATTACK_PATTERN = re.compile(
    r'''
    ''',
    re.VERBOSE,
)




class Summarizer:
    def __init__(self, file, writer: Writer):
        self.writer = writer
        if isinstance(file, str):
            self.lines = file.splitlines()
        else:
            # assume it is already an iterable of lines
            self.lines = [ln.rstrip("\n") for ln in file]

        self.unique_ips: set[str] = set()
        self.unique_users: set[tuple[str, str]] = set()
        self.bucket_req_times: defaultdict[str, list[float]] = defaultdict(list)
        self.bucket_unique_hits: defaultdict[str, set[tuple[str, str]]] = defaultdict(set)

        self.loop_lines()
    
    def loop_lines(self):
        for line in self.lines:
            self.dissect_line(line)

    def dissect_line(self, line):
        """Takes a single line, takes the values from it and saves it to another file.
        If regex fails, assume request is malicious and write it to a separate summarize file"""
        match = DEFAULT_PATTERN.match(line)
        if not match:
            attack_match = ATTACK_PATTERN.match(line)
            if attack_match:
                path = attack_match.group("path")
                status = attack_match.group("status")
                self.writer.attacks(f"{path} - {status}")
            else:
                print(f"Current malicious line: {line}")
            return
        
        ip           = match.group("ip")
        user_agent   = match.group("user_agent")
        raw_time  = match.group("time_local")
        #request_sec = float(match.group("request_time"))

        access_time = self.parse_nginx_time(raw_time)
        self.unique_ips.add(ip)
        user_key = (ip, user_agent)
        self.unique_users.add(user_key)

        bucket_label = self._bucket_label(access_time)   # e.g. "08:00-08:15"
        #self.bucket_req_times[bucket_label].append(request_sec)
        self.bucket_unique_hits[bucket_label].add(user_key)

    def parse_nginx_time(self, ts: str):
        """Converts nginx time into datetime format"""
        dt = datetime.strptime(ts[:-6], "%d/%b/%Y:%H:%M:%S")
        return dt.replace(tzinfo=timezone.utc)

    def _bucket_label(self, dt: datetime) -> str:
        """
        Return a 15-minute bucket label for the given datetime.
        Example: 08:07 -> "08:00-08:15"
        """
        minute_start = (dt.minute // 15) * 15
        start = dt.replace(minute=minute_start, second=0, microsecond=0)
        end   = start + timedelta(minutes=15)
        return f"{start.strftime('%H:%M')}-{end.strftime('%H:%M')}"
    
    def total_unique_ips(self) -> int:
        return len(self.unique_ips)

    def total_unique_users(self) -> int:
        return len(self.unique_users)

    def original_small_summary(self):
        """
        Build minimal dictionary from original logs

        * unique_users  in a 15-minutes bucket

        """
        summary = {}

        all_labels = set(self.bucket_unique_hits)

        for label in sorted(all_labels):
            uniq_cnt = len(self.bucket_unique_hits.get(label, []))


            summary[label] = {
                "unique_users": uniq_cnt
            }

        return summary

    def small_summary(self):
        """
        Build the final dictionary that combines:

        * unique_users  in a 15-minutes bucket
        * avg_req_s - average request time (seconds) for all requests

        """
        summary = {}

        all_labels = set(self.bucket_req_times) | set(self.bucket_unique_hits)

        for label in sorted(all_labels):
            uniq_cnt = len(self.bucket_unique_hits.get(label, []))

            req_times = self.bucket_req_times.get(label, [])
            avg_rt = round(mean(req_times), 3) if req_times else 0.0

            summary[label] = {
                "unique_users": uniq_cnt,
                "avg_req_s": avg_rt,
            }

        return summary

class CreateSummary:
    def __init__(self, writer: Writer):
        self.writer = writer

    def usage(self, summary: dict):
        self.writer.log("Supposedly nginx summary:\n\n")
        pretty_sum = self.print_dic(summary)
        #pretty_sum = self.origin_dic(summary)
        self.writer.log(pretty_sum)

    def potential_attacks(self, attacks: str):
        self.writer.log(attacks)
    
    def visual(self, summary: dict):
        self.writer.visual(summary)

    def origin_dic(self, summary: dict) -> str:
        """
        Print dictionary pretty from original log format

            00:00-00:15
                unique_users: 12
        """
        ordered_items = sorted(summary.items()) 
        lines: list[str] = []
        BLOCK_SIZE = 4

        for block_start in range(0, len(ordered_items), BLOCK_SIZE):
            block = ordered_items[block_start:block_start + BLOCK_SIZE]

            header_parts = [bucket.ljust(18) for bucket, _ in block]
            lines.append("   ".join(header_parts))

            uu_parts = [
                f"unique_users: {data.get('unique_users', '-')}".ljust(18)
                for _, data in block
            ]
            lines.append("   ".join(uu_parts))

        return "\n".join(lines).rstrip()

    def print_dic(self, summary: dict) -> str:
        """
        Print dictionary pretty

            00:00-00:15
                unique_users: 12
                avg_req_s: 0.041
        """
        ordered_items = sorted(summary.items()) 
        lines: list[str] = []
        BLOCK_SIZE = 4

        for block_start in range(0, len(ordered_items), BLOCK_SIZE):
            block = ordered_items[block_start:block_start + BLOCK_SIZE]

            header_parts = [bucket.ljust(18) for bucket, _ in block]
            lines.append("   ".join(header_parts))

            uu_parts = [
                f"unique_users: {data.get('unique_users', '-')}".ljust(18)
                for _, data in block
            ]
            lines.append("   ".join(uu_parts))

            rt_parts = [
                f"avg_req_s: {data.get('avg_req_s', '-')}".ljust(18)
                for _, data in block
            ]
            lines.append("   ".join(rt_parts))

            lines.append("")

        return "\n".join(lines).rstrip()




def main():
    reader = Reader()
    file_path = reader.file()
    file = reader.file_string()
    writer = Writer(file_path)
    log_summary = Summarizer(file, writer).small_summary()
    create_summary = CreateSummary(writer)
    create_summary.usage(log_summary)
    create_summary.visual(log_summary)


if __name__ == "__main__":
    main()
