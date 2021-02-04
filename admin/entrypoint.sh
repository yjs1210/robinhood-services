#!/bin/bash
# shellcheck disable=SC2034

TEXT_RESET_="\033[0m"
TEXT_BOLD_="\033[1m"
TEXT_RED_="\033[31m"
TEXT_GREEN_="\033[32m"
TEXT_YELLOW_="\033[33m"

# BASH Init Steps
{
  echo 'alias ls="ls --color"'
  echo 'export PS1="\[\033[1;34m\]\!\[\033[0m\] \[\033[1;35m\]\u\[\033[0m\]:\[\033[1;35m\]\W\[\033[0m\] $ "'
  echo 'export LC_ALL=C.UTF-8 && export LANG=C.UTF-8'
} > ~/.initfile

echo

cat << EOF
******************************************************************************************
*                                ${PROJECT_NAME} Administration
******************************************************************************************
EOF

exec bash --init-file ~/.initfile
