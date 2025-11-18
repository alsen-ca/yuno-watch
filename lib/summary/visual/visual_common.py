from .matplotlib_setup import plt
from typing import Tuple

def _configure_axes(ax: plt.axes.Axes) -> None:
    ax.set_xlabel("Time")
    ax.set_ylabel("Requests")

    ax.grid(False)

def _make_figure() -> Tuple[plt.figure.Figure, plt.axes.Axes]:
    fig = plt.figure(figsize=(10, 5))
    ax = fig.add_subplot(1, 1, 1)
    _configure_axes(ax)

    plt.setp(ax.get_xticklabels(), rotation=45)
    ax.margins(x=0)
    fig.tight_layout(pad=0)

    return fig, ax

__all__ = ["_configure_axes", "_make_figure"]
