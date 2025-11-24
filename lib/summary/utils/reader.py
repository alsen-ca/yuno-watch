def file_content(file_path):
    """Returns the actual file"""
    with open(file_path, "r", encoding="utf-8") as f:
        return f.read()
