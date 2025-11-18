## Nginx Format
For Yuno Watch to perform summaries and analysis, one can define in the configuration which type of Log Output Format Nginx uses.

Depending on the format used by Nginx, NGINX_LOG_FORMAT might need to be modified to parse the logs appropiatedly.

Log Format can be checked at /etc/nginx/nginx.conf

### Default Format
By default, Nginx comes with the following Format:

    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                '$status $body_bytes_sent "$http_referer" '
                '"$http_user_agent" "$http_x_forwarded_for"';

Used in configuration as NGINX_LOG_FORMAT="default"

### Req Format
Log Format with Request Time; adds a value for request time for each request.

    '$remote_addr - $remote_user [$time_local] "$request" '
    '$status $body_bytes_sent "$http_referer" '
    '"$http_user_agent" "$http_x_forwarded_for" '
    'rt="$request_time"';

Used in configuration as NGINX_LOG_FORMAT="req"

### Custom Format
If you have another Log Format, you need to do more work.
Also, in oder for it to work, you need to name the required files appropiatedly.

Used in configuration as NGINX_LOG_FORMAT="custom" or NGINX_LOG_FORMAT="my-format" or whatever you choose.

For the following explanations, we will assume the format will be called 'custom'

#### Regex
Create a new file lib/summary/log_regex/custom.txt that includes your Regex for reading the requests.

This must use the format used by the 're' library of python.

### Request Parsing
Create a new file lib/summary/log_parser/custom.py that performs whatever parsing you need.

Use lib/summary/summarized_log.py -> CreateSummary.usage as reference

### Graph Generation
(Optional) Create a new file lib/summary/visual/visual_custom.py that generates a Matplotlib Graph with your values.

Use visual_default.py and visual_req.py as reference.

Return dictionary.