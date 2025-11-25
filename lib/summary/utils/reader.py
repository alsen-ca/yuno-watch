import json

def file_content(file_path):
    """Returns the actual file"""
    with open(file_path, "r", encoding="utf-8") as f:
        return f.read()

def load_data_from_json(dir_output: str, data_type: str) -> dict:
    with open(f"{dir_output}/summary_data.json", "r") as f:
        data = json.load(f)
    return data[f"{data_type}"]
