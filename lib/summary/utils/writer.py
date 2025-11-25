import json
from datetime import datetime

def clean_file(path: str):
    """Remove any existing content from the log file"""
    with open(path, "w", encoding="utf-8") as f:
        f.write("")

def write_log(path: str, content: str):
    """Appends text to an existing file"""
    with open(path, "a", encoding="utf-8") as f:
        f.write(content)
        f.write("\n")

def write_bytes(dir_output: str, content):
    """Appends bytes to an existing file"""
    with open(f"{dir_output}/visual.png", "wb") as f:
        f.write(content)

def save_summary_data(dir_output: str, filename: str, summary: dict, unique_ips_count: int):
    """Save summary data to a JSON file."""
    date_str = filename.split("-")[-1]
    date_obj = datetime.strptime(date_str, "%Y%m%d")
    formatted_date = date_obj.strftime("%d.%m.%Y")
    summary_data = {
        "date": formatted_date,
        "total_unique_ips": unique_ips_count,
        "summary": summary
    }

    summary_json_filename = f"{dir_output}/summary_data.json"
    with open(summary_json_filename, "w", encoding="utf-8") as f:
        json.dump(summary_data, f, indent=4)
