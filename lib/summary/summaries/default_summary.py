from summaries.base_summarizer import BaseSummarizer
import utils.writer as writer

class Summarizer(BaseSummarizer):
    def generate_summary(self) -> dict:
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

    def dissect_line(self, line):
        """Takes a single line, takes the values from it and saves it to another file.
        If regex fails, assume request is malicious and write it to a separate summarize file"""
        match = self.pattern.match(line)
        if not match:
            attack_match = self.attack_pattern.match(line)
            if attack_match:
                path = attack_match.group("path")
                status = attack_match.group("status")
                writer.write_log(f"{self.dir_output}/attacks.log", f"{path} - {status}")
            else:
                print(f"Current malicious line: {line}")
            return
        
        ip = match.group("ip")
        user_agent = match.group("user_agent")
        raw_time = match.group("time_local")
        status = match.group("status")
        path = match.group("path")
        method = match.group("method")

        self._update_status_path_freq(method, status, path)

        access_time = self.parse_nginx_time(raw_time)
        self.unique_ips.add(ip)
        user_key = (ip, user_agent)
        self.unique_users.add(user_key)

        bucket_label = self._bucket_label(access_time)   # e.g. "08:00-08:15"
        self.bucket_unique_hits[bucket_label].add(user_key)


    def print_dic(self, summary: dict) -> str:
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

            lines.append("")

        return "\n".join(lines).rstrip()
