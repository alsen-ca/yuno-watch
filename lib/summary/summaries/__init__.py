from importlib import import_module
import os

def get_summarizer_class():
    log_format = os.environ.get("NGINX_LOG_FORMAT")
    module_name = f"summaries.{log_format}_summary"
    try:
        module = import_module(module_name)
        return module.Summarizer
    except ImportError:
        raise ValueError(f"Unsupported log format: {log_format}")
