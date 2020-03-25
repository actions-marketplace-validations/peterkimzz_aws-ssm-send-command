#!/bin/bash

# 이 커맨드 아래 명령어 중 에러가 발생하면 즉시 스크립트 실행을 중단시킴
set -e

function main() {
  sanitize "${INPUT_INSTANCE_ID}" "instnace_id"
  sanitize "${INPUT_COMMANDS}" "commands"

  init
  send_command
}

function sanitize() {
  if [ -z "${1}" ]; then
    >&2 echo "${2} is required. Did you set parameter ${2}?"
    exit 1
  fi
}

function init() {
  export INSTANCE_ID=$INPUT_INSTANCE_ID
  export COMMANDS=$INPUT_COMMANDS
  export DOCUMENT_NAME=$INPUT_DOCUMENT_NAME

  export COMMENT=$INPUT_COMMENT
  export WORKING_DIRECTORY=$INPUT_WORKING_DIRECTORY
}

function send_command() {
  echo "== START SEND-COMMAND"
  aws ssm send-command \
    --instance-ids ${INSTANCE_ID} \
    --document-name ${DOCUMENT_NAME} \
    --comment ${COMMENT} \
    --parameters \
      "{"workingDirectory": ["${WORKING_DIRECTORY}"], "commands":["${COMMENT}"]}"

  echo "== FINISHED SEND_COMMAND"
}

main