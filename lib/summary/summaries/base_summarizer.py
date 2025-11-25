from datetime import datetime, timezone, timedelta
from collections import defaultdict, Counter
import re

class BaseSummarizer:
    def __init__(self, lines: str, pattern, attack_pattern, dir_output):
        if isinstance(lines, str):
            self.lines = lines.splitlines()
        else:
            # assume it is already an iterable of lines
            self.lines = [ln.rstrip("\n") for ln in lines]
        self.pattern = pattern
        self.attack_pattern = attack_pattern
        self.dir_output = dir_output
        self.unique_ips: set[str] = set()
        self.unique_users: set[tuple[str, str]] = set()
        self.bucket_unique_hits: defaultdict[str, set[tuple[str, str]]] = defaultdict(set)
        self.status_path_freq = Counter()
        self.unique_4xx_paths = set()


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

    def _update_status_path_freq(self, method, status, path):
        self.status_path_freq[(method, status, path)] += 1
        if status.startswith("4"):
            self.unique_4xx_paths.add(path)

    def get_status_path_freq(self):
        groups = {
            "2xx": [],
            "3xx": [],
            "4xx": [],
            "5xx": [],
        }
        for (method, status, path), freq in self.status_path_freq.most_common():
            if status.startswith("2"):
                groups["2xx"].append(f"{method} {status} {path} {freq}")
            elif status.startswith("3"):
                groups["3xx"].append(f"{method} {status} {path} {freq}")
            elif status.startswith("4"):
                groups["4xx"].append(f"{method} {status} {path} {freq}")
            elif status.startswith("5"):
                groups["5xx"].append(f"{method} {status} {path} {freq}")

        result = []
        for group in ["2xx", "3xx", "4xx", "5xx"]:
            result.extend(groups[group])
            result.append("\n\n\n\n")

        # Remove trailing blank lines if the last group is empty
        while result and result[-1] == "":
            result.pop()

        return "\n".join(result)


    def get_4xx_paths(self):
        return "\n".join(self.unique_4xx_paths)
        
