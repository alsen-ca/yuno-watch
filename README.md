# YunoWatch
Automated lightweight Nginx log workflow – rotation, compression, deletion, parsing, summarising, plus rule generation to block threats.


## Notice
This is a work in progress. You might make a copy of this repo and use the files according to the License, but don't expect the package as a whole to work.

This is not a bundled package, so you might need to perform additional steps than those written here in order for the package to work.
Updates might also break existing configurations. Proceed with caution.

## Requirements
- Root / sudo access: Required for installation and performing activating scripts
- Operating System: Linux (eventually tested on Fedora, AlmaLinux)
- Git (preferred, but curl also possible): Required for installation
- Docker (For Summaries. Not strictly neccesary - can be deactivated on [Configuration](conf/CONFIGURATION.md#avoiding-docker))

## Installation
- cd ~/Downloads
- git clone https://github.com/alsen-ca/yuno-watch.git
- Optional - Change default configurations if needed
- yuno-watch/install.sh

## CLI-Wrapper
To call the scripts for this package, the cli-wrapper at /usr/local/bin should have been installed when you sh yuno-watch/install.sh

This allows you to call the scripts with the appropiate permissions like

    yuno tests all (Requires bats-core)
    yuno perform import 2025-11
    yuno perform summary 2025-12-25

If you were to want a different prefix for calling the scripts, just rename the CLI-Wrapper.

The cli accepts following commands:

1. tests - Optional (requires bats-core installed). Checks  whether the script has been installed correctly.
2. [action](#actions) - Long term functionality of the package; repeated call of scripts by systemd timer.
3. [perform](#performs) - One time command. Can be used to test the package by hand to decide if it works for you.
4. docker - Not yet implemented. Used to perform all scripts that use Python.

## Configurations
Configurations on this project refer mostly to environmental variables that are used by the scripts of the library.

Any file manually added in the conf directory overwrites the default values.
Add your custom configuration files to avoid updates or some installation scripts to overwrite your values.
The CLI-Wrapper *should* keep your Configurations save.

Note however, modifying some configurations after the project installation might lead to issues, e.g, broken system paths for already existing content.
Changing the NAME= would specially cause issues even if changed before the actual installation. Proceed with caution.

If you wish to change any configuration, it is recommended to aboid changing the yuno-watch.conf directly.
Instead, add a new file (or edit an already existing one) in the /etc/yuno-watch/ directory with your variables value.

These files must end in .conf and be uppercase. Take conf/example.conf.inactive as an example (Remove .inative in order to use)

[See possible configurations and their explanations](conf/CONFIGURATION.md)

Alternatively (not yet implemented), you can also call a script with a certain Configuration variable.
Now, this variable will apply to only this one command you are activating. Example:

    yuno perform summary 2025-10-11 NGINX_LOG_FORMAT="req"

## Quick Start
This Quick Start assumes that the default configurations were used.

1. If not yet done, follow the Installation steps.
2. Do some basic 'perfom' calls to test if it was correctly installed.
For this example, we will expect an 'old'(preferably at least yesterday's) log in /var/log/nginx/ :

    2.1 - Find the name of the file

    - sudo ls /var/log/nginx

    And expect something like /var/log/nginx/access.log-20251122. For such a case: YY=2025, mm=11, dd=22. 
    
    2.2 - Now you can call the 'perform rotate' call:

    - yuno perform rotate 2025-11-22

    2.3 - Confirm that the file no longer is at /var/log/nginx and that it was moved to the package's folder:

    - sudo ls /var/log/nginx
    - sudo ls /var/archive/yuno-watch/og_nginx/2025-11/22

    2.4 - Do a simple summary for this file:

    - yuno perform summary 2025-11-22

    2.5 - Confirm that the summary has been created:

    - sudo cat /var/cache/yuno-watch/sum_nginx/2025-11/22/summary.log

3. Now that we have confirmed that it works as intended, you can either activate all the actions (the whole package) or only [activate certain actions](#actions).

    - yuno action all 
    
    Or for example:

    - yuno action new-folder
    - yuno action rotate-nginx

## What YunoWatch offers
YunoWatch offers the option to rotate, compress, delete and summarize logs, all automatically.

A future update will also take the summarized attack patterns, make a ML algorithm learn from it and allow Nginx to ask if a suspicious request should be allowed.

### Rotation and Compression
Original logs will be moved from the folder where nginx writes them to NGINX_LOGS.
Here they are chowned by this lib's created user.

After performing the summary, the log is compressed.

### Summaries
The summaries will be written to SUMMARY_SUB.

This folder can be deleted at any time and could be recreated anew, as long as the original logs exist.

### Deletetion
Original logs will be deleted after a certain amount of time passes (default 6 months) on ROTATION_SUB.

Summaries derivated from original logs will be moved at this time to ROTATION_SUB.

## Actions
Core of the package. These are the functionalities that work long-term. For example rotating the files and making summary every day.
For these commands to be activated on a repetitive manner, an action must be activated.

These actions can be called by yuno action [custom-action].

For example:

    yuno action new-folder
    yuno action rotate-nginx
    yuno action perform-summary

Do note that some actions need to work together in order to work.
For this a 'depends_on' has been added to the actions

### all-actions
Activates all the possible actions.

This list of actions can be changed on Configuration WHICH_ALL_ACTIONS.

### new-folder
Creates a monthly folder

Creates new folders where logs will be rotated and summarized to:
    
    ROTATION_SUB/<YY-mm> and
    SUMMARY_SUB/<YY-mm>

### rotate-nginx
Rotates nginx logs daily from original NGINX_LOGS path to ROTATION_SUB.

depends_on :new-folder

### perform-summary
Does daily summaries from yesterday's(by default) logs of ROTATION_SUB.

Also creates Visual summary if activated.

depends_on :new-folder - :rotate-nginx

### merge-attack-patterns
Takes all ATTACK_LOG_OUTPUT and puts it on a summary

depends_on :new-folder - :rotate-nginx - :perform-summary

### compress-og
Compresses original nginx logs of ROTATION_SUB

Compresses Summaries that were moved after the Deletion of the original files happened ([view Delete](#deletetion))

depends_on :new-folder - :rotate-nginx

### auto-delete
Performs deletion of original files after KEEP_OG_LOGS_FOR momths.

depends_on :new-folder - :rotate-nginx

### observe
Simlar to a cron job. Constantly performs curl requests to your website to check whether it is up.

If it is not successfull, it should notify the admins. How it gets to do this, it awaits to be seen.. I will probably do this by ntfy.

## Performs
Performs are scripts that are only activated once when they are called and not something constantly called like Actions.

These perform commands can be activated as long as the data they need is available to work.

Performs are called like

    yuno perform summary <YY-mm-dd>
    yuno perform import <YY-mm>

### Summary
Performs the summary for specific date or date range.

    yuno perform summary <YY-mm-dd>

If a date range (month or year) is chosen, then it will create an individual summary per day. If you have PERFORM_VISUAL_SUMMARY, you might not want this.

For such a case, you can call the command --no-visual and alternatively --no-pattern

    yuno perform summary --no-visual --no-pattern --year <YY>

This is equivalent to writing

    yuno perform summary --year <YY> --config PERFORM_VISUAL_SUMMARY=false PERFORM_SUMMARY_ATTACK=false

You can also just perform the visual summary for a month. Only possible if summary for month already happened

    yuno perform summary --no-pattern --no-basic <YY-mm> PERFORM_VISUAL_SUMMARY=true INTERVAL_VISUAL_SUMMARY="monthly"

### Import
If you already have logs and want them summarized or want them on the new structure, this is the command.

It will copy (note: not move. You would need to delete them manually afterwards if you wish to save space) a month's worth of files to the location used by YunoWatch.

You need to first have the files copied on a whole folder at SUMMARY_SUB and then

    yuno perform import <YY-mm>

As any before, this can also be called with a custom SUMMARY_SUB if your files lie at another location.
Do note however, that the target directory must include all the files of a single month on a single folder.
This also asumes that the files inside follow the nginx naming convention: access.log-%Y%m%d (e.g., access.log-20251025).
For example:

    ls /var/backup/my-old-logs/2025-04 = access.log-20250401, access.log-20250402, access.log-20250403, access.log-20250404, etc.   
    yuno perform import 2025-04 SUMMARY_SUB="/var/backup/my-old-logs"

The expected output would be:

    $ROTATION_SUB/2025-04/01/access.log-20250401 $ROTATION_SUB/2025-04/01/error.log-20250401
    $ROTATION_SUB/2025-04/02/access.log-20250402 $ROTATION_SUB/2025-04/01/error.log-20250402 
    ...