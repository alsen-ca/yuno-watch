# Configuration
The variables defined in yuno-watch.conf are used by the scripts of the library. Feel free to modify them.

But note correct naming conventions. For example, paths with invalid characters like whitespace will cause some scripts to fail.

You can have multiple configuration files, but try not to repeat you configuration on multiple files, lest one file causes an unexpected overwrite to another.

## NGINX_LOG_FORMAT
For Yuno Watch to perform summaries and analysis, one can define in the configuration which type of Log Output Format Nginx uses.

Depending on the format used by Nginx, NGINX_LOG_FORMAT might need to be modified to parse the logs appropiatedly.

Be noted that the default_log regex will still work with your regex if you added additional rules, but not if you deleted any.

Log Format can be checked at /etc/nginx/nginx.conf

### Default Format
By default, Nginx comes with the following Format:

    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                '$status $body_bytes_sent "$http_referer" '
                '"$http_user_agent" "$http_x_forwarded_for"';

This is used for Configurations as NGINX_LOG_FORMAT="default"

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

This result must be readable by the 're' library of python.

### Request Parsing
Create a new file lib/summary/log_parser/custom.py that performs whatever parsing you need.

Use lib/summary/summarized_log.py -> CreateSummary.usage as reference

### Graph Generation
(Optional) Create a new file lib/summary/visual/visual_custom.py that generates a Matplotlib Graph with your values.

Use visual_default.py and visual_req.py as reference.

Return dictionary.


## Avoiding Docker
If you don't want to use Docker, you can also run the summary scripts locally.

This is, however, not recommended for Production.
This is specially the case for the Visual Summary and eventually the ML algorithm for rule-generation and Request blocks.

The conf/local_python.conf.inactive suffices if you want this, making Docker not needed to be installed.

### Before installation
If you have yet to install the package, you can simply rename the file conf/local_python.conf.inactive, like so:

    cd $HOME/Downlaods/yuno-watch
    mv conf/local_python.conf.inactive conf/local_python.conf

You can the proceed to installation if no further changes on the Configuration are needed.

Note that not deactivating the use of Docker before the installation won't make the package 'installation' bigger.
You simply will get an error if you try to initiate any command that requires the package's user to be in the Docker group.

If you are unsure whether you wish to use Docker or not, you can change the Configuration at any time.
The next time some script is called, it will read the new value of you configuration.

### After installation
If you already installed the package but still have the original code in Downlodads:

    sudo cp $HOME/Downloads/yuno-watch/conf/local_python.conf.inactive /etc/yuno-watch/local_python.conf
    sudo chown yuno-watch:yuno-watch /etc/yuno-watch/local_python.conf
    sudo chmod 600 /etc/yuno-watch/local_python.conf

If you have deleted the code from Downloads, create a new (or modify your existing configuration file) with the following variables:

    sudo bash -c 'echo "export USES_DOCKER=false" >> /etc/yuno-watch/nodocker.conf'
    sudo chown yuno-watch:yuno-watch /etc/yuno-watch/nodocker.conf
    sudo chmod 600 /etc/yuno-watch/nodocker.conf
