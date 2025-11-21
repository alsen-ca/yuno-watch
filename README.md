# YunoWatch
Automated lightweight Nginx log workflow – rotation, compression, deletion, parsing, summarising, plus rule generation to block threats.


## Notice
This is a work in progress. You might make a copy of this repo and use the files according to the License, but the Quickstart won't work.

This is not a bundled package, so you might need to perform additional steps than those written here in order for the library to work.

## Requirements
- Root / sudo access: Required for installation and changing performing some actions
- Operating System: Linux (tested on Fedora, CentOS)
- Git (preferred, but curl also possible): Required for installation
- Docker (Or change PERFORM_SUMMARY= in Configuration)

## Installation
- cd ~/Downloads
- git clone https://github.com/alsen-ca/yuno-watch.git
- Optional - Change default configurations if needed
- yuno-watch/install.sh

## CLI-Wrapper
To call the scripts for this package, the cli-wrapper at /usr/local/bin should have been install when you yuno-watch/install.sh

This allows you to call the scripts with the appropiate permissions like

    yuno tests all
    yuno perform summary 2025-12-25

If you were to want a different prefix for calling the scripts, just rename the file.

The actions allowed are the following:


1. tests - Optional (requires bats installed). Checks  whether the script has been installed correctly
2. [action](#actions) - Long term functionality of the package
3. [perform](#performs)
4. docker

## Configurations
Configurations on this project refer mostly to environmental variables that are used by the scripts of the library.

Any file manually added in the conf.d folder overwrites the default values.

Note however, modifying some configurations after the project installation might lead to issues, e.g, broken system paths for already existing content.

Changing the NAME= would require changing the source import in many of the .sh and .py files. Proceed with caution.

### Modifying Configurations
If you wish to change any configuration, change the value of your variable on the yuno-watch.conf

[See possible configurations and their explanations](CONFIGURATION.md)

You can also call a script with a certain Configuration variable, and that variable will apply to only this one command. Example:

    yuno perform summary 2025-10-11 NGINX_LOG_FORMAT="req"

## Quick Start

1. If not yet done, follow the Installation steps.
2. Get a summary of the steps that will happen

    - yuno is-ready

3. Activate the library to create user, paths, etc.

    - yuno activate
4. Either activate all the actions or only [activate certain actions](#actions).

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

This folder can be deleted at any time and could be recreated anew with the original logs.

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

## Performs
Performs are scripts that are only activated once when they are called and not something constant called like Actions.

These perform commands can be activated as long as the data they need is available to work.

Performs are called like

    yuno perform summary <YY-mm-dd>
    yuno perform import <YY-mm>

### Summary
Performs the summary for specific date or date range.

    yuno perform summary <YY-mm-dd>
    yuno perform summary --month <YY-mm>
    yuno perform summary --year <YY>

If a date range (month or year) is chosen, then it will create an individual summary per day. If you have PERFORM_VISUAL_SUMMARY, you might not want this.

For such a case, you can call the command --no-visual and alternatively --no-pattern

    yuno perform summary --no-visual --no-pattern --year <YY>

This is equivalent to writing

    yuno perform summary --year <YY> PERFORM_VISUAL_SUMMARY=false PERFORM_SUMMARY_ATTACK=true

You can also just perform the visual summary for a month. Only possible if summary for month already happened

    yuno perform summary --no-pattern --no-basic PERFORM_VISUAL_SUMMARY=true INTERVAL_VISUAL_SUMMARY="monthly"

### Import
If you already have logs and don't have them summarized or want them on the new structure, this is the command.

It will copy (note: not move. You would need to delete them manually if you wish to save space) a month's worth of files to the location used by YunoWatch.

You need to first have the files copied on a whole folder at SUMMARY_SUB and then

    yuno perform import <YY-mm>

As any before, this can also be called with a custom SUMMARY_SUB if your files lie at another location.
Do note however, that the target directory must include all the files of a single month on a single folder.
This also asumes that the files inside follow the nginx naming convention: *access.log-%Y%m%d (e.g., access.log-20251025)
For example:

    ls /var/backup/my-old-logs/2025-04 = access.log-20250401, access.log-20250402, access.log-20250403, access.log-20250404, etc.   
    yuno perform import SUMMARY_SUB="/var/backup/my-old-logs/2025-04"

The expected output would be:

    $ROTATION_SUB/2025-04/01/access.log-20250401 $ROTATION_SUB/2025-04/01/error.log-20250401
    $ROTATION_SUB/2025-04/02/access.log-20250402 $ROTATION_SUB/2025-04/01/error.log-20250402 
    ...