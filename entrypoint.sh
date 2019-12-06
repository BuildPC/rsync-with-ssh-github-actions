#!/bin/bash
# This file is adapted from https://github.com/alinz/ssh-scp-action and https://github.com/AEnterprise/rsync-deploy.
# All the actual credit goes to the original developers.
set -eu


setupSSH(){
    SSH_PATH="$HOME/.ssh"
    mkdir -p "$SSH_PATH"
    touch "$SSH_PATH/known_hosts"
    echo "$INPUT_KEY" > "$SSH_PATH/deploy_key"

    chmod 700 "$SSH_PATH"
    chmod 600 "$SSH_PATH/known_hosts"
    chmod 600 "$SSH_PATH/deploy_key"

    eval $(ssh-agent)
    ssh-add "$SSH_PATH/deploy_key"

    ssh-keyscan -t rsa $INPUT_HOST >> "$SSH_PATH/known_hosts"
}


run_rsync(){
    sh -c "rsync $INPUT_ARGS -e 'ssh -i $SSH_PATH/deploy_key -o StrictHostKeyChecking=no -p $INPUT_PORT' $GITHUB_WORKSPACE $INPUT_USER@$INPUT_HOST:$INPUT_DESTINATION"
}

executeSSH() {
  local LINES=$1
  local COMMAND=""

  # holds all commands separated by semi-colon
  local COMMANDS=""

  # this while read each commands in line and
  # evaluate each line agains all environment variables
  while IFS= read -r LINE; do
    LINE=$(eval 'echo "$LINE"')
    LINE=$(eval echo "$LINE")
    COMMAND=$(echo $LINE)

    if [ -z "$COMMANDS" ]; then
      COMMANDS="$COMMAND"
    else
      COMMANDS="$COMMANDS;$COMMAND"
    fi
  done <<< $LINES

  echo "$COMMANDS"
  ssh -o StrictHostKeyChecking=no -p ${INPUT_PORT:-22} $INPUT_USER@$INPUT_HOST "$COMMANDS"
}

setupSSH
echo "+++++++++++++++++++RUNNING BEFORE SSH+++++++++++++++++++"
executeSSH "$INPUT_SSH_BEFORE"
echo "+++++++++++++++++++DONE RUNNING BEFORE SSH+++++++++++++++++++"
echo "+++++++++++++++++++RUNNING rsync+++++++++++++++++++"
run_rsync
echo "+++++++++++++++++++DONE RUNNING rsync+++++++++++++++++++"
echo "+++++++++++++++++++RUNNING AFTER SSH+++++++++++++++++++"
executeSSH "$INPUT_SSH_AFTER"
echo "+++++++++++++++++++DONE RUNNING AFTER SSH+++++++++++++++++++"
