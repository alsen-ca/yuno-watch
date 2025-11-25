import io
from .matplotlib_setup import plt
from typing import Any, List, Tuple
from .common import _make_figure

class VisualWithRequest:
    def __init__(self, date: str, ips: int, bucket_dic: dict):
        self.bucket_dic = bucket_dic
        self.date = date
        self.ips = ips

    def _extract_values(self):
        buckets = list(self.bucket_dic.keys())

        uniq_users = []
        req_time = []

        for b in buckets:
            entry = self.bucket_dic[b]
            uniq_users.append(entry["unique_users"])
            req_time.append(entry["avg_req_s"])

        return buckets, uniq_users, req_time

    def render(self) -> bytes:
        buckets, uniq_users, req_time = self._extract_values()
        fig, ax = _make_figure()

        info_text = f"Date: {self.date}\nAmount of Unique IP Addresses: {self.ips}"
        ax.text(
            0.02,
            1.15 * max(uniq_users),
            info_text,
            verticalalignment="bottom",
            bbox=dict(boxstyle="round", facecolor="white", alpha=0.8),
        )

        ax.plot(buckets, uniq_users, marker="o", color="red", label="Unique users")
        ax.plot(buckets, req_time, marker="o", color= "blue", label="Avergae request time")
        ax.legend()

        buf = io.BytesIO()
        fig.savefig(buf, format="png", bbox_inches="tight")
        plt.close(fig)
        return buf.getvalue()
