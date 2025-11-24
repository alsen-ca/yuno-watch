from datetime import datetime, timezone, timedelta
from collections import defaultdict
import re

class BaseSummarizer:
    def __init__(self, lines: str, pattern, attack_pattern):
        if isinstance(lines, str):
            self.lines = lines.splitlines()
        else:
            # assume it is already an iterable of lines
            self.lines = [ln.rstrip("\n") for ln in lines]
        self.pattern = pattern
        self.attack_pattern = attack_pattern
        self.unique_ips: set[str] = set()
        self.unique_users: set[tuple[str, str]] = set()
        self.bucket_unique_hits: defaultdict[str, set[tuple[str, str]]] = defaultdict(set)


    def summarize(self):
        self.loop_lines()
        return self.generate_summary()

    def loop_lines(self):
        for line in self.lines:
            self.dissect_line(line)

    def dissect_line(self, line):
        raise NotImplementedError("Subclasses must implement this function")

    def parse_nginx_time(self, ts: str):
        """Converts nginx time into datetime format"""
        dt = datetime.strptime(ts[:-6], "%d/%b/%Y:%H:%M:%S")
        return dt.replace(tzinfo=timezone.utc)

    def _bucket_label(self, dt: datetime) -> str:
        """
        Return a 15-minute bucket label for the given datetime.
        Example: 08:07 -> "08:00-08:15"
        """
        size_buck = 15
        minute_start = (dt.minute // size_buck) * size_buck
        start = dt.replace(minute=minute_start, second=0, microsecond=0)
        end   = start + timedelta(minutes=size_buck)
        return f"{start.strftime('%H:%M')}-{end.strftime('%H:%M')}"
    
    def total_unique_ips(self) -> int:
        return len(self.unique_ips)

    def total_unique_users(self) -> int:
        return len(self.unique_users)

    def generate_summary(self):
        raise NotImplementedError("Subclasses must implement this method")
    
    def print_dic(self):
        raise NotImplementedError("Subclasses must implement this method")
