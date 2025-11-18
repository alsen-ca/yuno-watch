# yuno-watch
Automated lightweight Nginx log workflow – rotation, compression, deletion, parsing, summarising, plus rule generation to block threats.


## Notice
This is a work in progress. You might make a copy of this repo and use the files according to the License, but the Quickstart won't work.

This is not a bundled package, so you might need to perform additional steps than those written here in order for the library to work.

## Requirements
- Root / sudo access: Required for installation and changing performing some actions
- Operating System: Linux (tested on Fedora, CentOS)
- Docker (Or change PERFORM_SUMMARY= in Configuration)

## Installation
- cd ~/Downloads
- git clone https://github.com/alsen-ca/yuno-watch.git
- Optional - Change default configurations if needed
- yuno-watch/install.sh

## Configurations
Configurations on this project refer mostly to environmental variables that are used by the scripts of the library.

Any file manually added in the conf.d folder overwrites the default values.

Note however, modifying some configurations after the project installation might lead to issues, e.g, broken system paths for already existing content.

Changing the NAME= would require changing the source import in many of the .sh and .py files. Proceed with caution.

### Modifying Configurations
If you wish to change any configuration, add the variable to the .conf file to the folder conf.d

[See possible configurations and their explanations](conf.d/CONFIGURATION.md)

conf.d/yuno.conf.inactive shows an example to change which type of Log Format Nginx has on its logs. (Rename to conf.d/yuno.conf to activate)

## Quick Start

1. If not yet done, follow the Installation steps.
2. Get a summary of the steps that will happen

    - yuno-watch is-ready

3. Activate the library to create user, paths, etc.

    - yuno-watch activate
4. Either activate all the actions or only [activate certain actions](#actions).

    - yuno-watch action all 
    
    Or for example:

    - yuno-watch action new-folder
    - yuno-watch action rotate-nginx

## Functions
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
These actions can be called by yuno-watch action [custom-action].

For example:

    yuno-watch action new-folder
    yuno-watch action-rotate-nginx
    yuno-watch action perform-summary

Do note however, that some actions need to work together in order to work.
For this a 'depends_on' has been added to the actions

### all-actions
Activates all the possible actions.

What this includes can be configured from WHICH_ALL_ACTIONS.

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

depends_on :new-folder - :rotate-nginx - perform-summary

### compress-og
Compresses original nginx logs of ROTATION_SUB

Compresses Summaries that were moved after the Deletion of the original files happened ([view Delete](#deletetion))

depends_on :new-folder - :rotate-nginx

### auto-delete
Performs deletion of original files after KEEP_OG_LOGS_FOR momths.

depends_on :new-folder - :rotate-nginx