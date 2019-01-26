#!/bin/sh

while [ "${#}" -gt 0 ]
do
  case "${1}" in
    --aws-access-key-id)
      AWS_ACCESS_KEY_ID="${2}" &&
      AWS_SECRET_ACCESS_KEY="$(pass show aws/iam/${2})" &&
        shift 2 &&
        true
    ;;
    --region)
      REGION="${2}" &&
        shift 2 &&
        true
    ;;
    --output)
      OUTPUT="${2}" &&
        shift 2 &&
        true
    ;;
    *)
      echo "Unknown Option" &&
        echo "${1}" &&
        echo "${@}" &&
        echo "${0}" &&
        exit 66 &&
        true
    ;;
  esac &&
    true
done &&
if [ ! -d "${HOME}/.aws" ]
then
  mkdir "${HOME}/.aws" &&
    true
fi &&
if [ ! -f "${HOME}/.aws/credentials" ]
then
  touch "${HOME}/.aws/credentials" &&
    if [ ! -z "${AWS_ACCESS_KEY_ID}" ]
    then
      echo "aws_access_key_id = ${AWS_ACCESS_KEY_ID}" >> "${HOME}/.aws/credentials" &&
        true
    fi &&
    if [ ! -z "${AWS_SECRET_ACCESS_KEY}" ]
    then
      echo "aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}" >> "${HOME}/.aws/credentials" &&
        true
    fi &&
    echo >> "${HOME}/.aws/credentials" &&
    chmod 0400 "${HOME}/.aws/credentials" &&
    true
  fi &&
  if [ ! -f "${HOME}/.aws/config" ]
    touch "${HOME}/.aws/config" &&
    if [ ! -z "${REGION}" ]
    then
      echo "region = ${REGION}" >> "${HOME}/.aws/config" &&
        true
    fi &&
    if [ ! -z "${OUTPUT}" ]
    then
      echo "output = ${OUTPUT}" >> "${HOME}/.aws/config" &&
        true
    fi &&
    echo >> "${HOME}/.aws/config" &&
    chmod 0400 "${HOME}/.aws/config" &&
    true
  fi &&
  true
