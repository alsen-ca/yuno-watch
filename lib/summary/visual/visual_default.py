import io
from matplotlib.ticker import FixedFormatter, FixedLocator
from typing import Any, List, Tuple

from .common import _make_figure
from .matplotlib_setup import plt

class VisualDefault:
    def __init__(self, date: str, ips: int, bucket_dic: dict):
        self.bucket_dic = bucket_dic
        self.date = date
        self.ips = ips

    def _extract_values(self) -> Tuple[List[Any], List[int]]:
        buckets = list(self.bucket_dic.keys())
        uniq_users = []

        for b in buckets:
            entry = self.bucket_dic[b]
            uniq_users.append(entry["unique_users"])

        return buckets, uniq_users

    def render(self) -> bytes:
        buckets, uniq_users = self._extract_values()
        fig, ax = _make_figure()

        info_text = f"Date: {self.date}\nAmount of Unique IP Addresses: {self.ips}"
        ax.text(
            0.02,
            1.15 * max(uniq_users),
            info_text,
            verticalalignment="bottom",
            bbox=dict(boxstyle="round", facecolor="white", alpha=0.8),
        )

        ax.plot(buckets, uniq_users, marker=None, color="red", label="Unique users")
        orig_ticks = ax.get_xticks()

        # Hourly enumeration for ticks
        tick_positions = orig_ticks[::4][:25]
        time_labels = [str(i) for i in range(len(tick_positions))]
        ax.xaxis.set_major_locator(FixedLocator(tick_positions))
        ax.xaxis.set_major_formatter(FixedFormatter(time_labels))
        
        ax.legend()
        buf = io.BytesIO()
        fig.savefig(buf, format="png", bbox_inches="tight")
        plt.close(fig)
        return buf.getvalue()
