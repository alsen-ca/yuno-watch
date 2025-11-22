def clean_file(path: str):
    """Remove any existing content from the log file"""
    with open(path, "w", encoding="utf-8") as f:
        f.write("")

def write_log(path: str, content):
    """Appends text to an existing file"""
    with open(path, "a", encoding="utf-8") as f:
        f.write(content)
        f.write("\n")  

def write_bytes(path, content):
    """Appends bytes to an existing file"""
    with open(path, "wb") as f:
        f.write(content)
