#!/bin/sh

BUCKET="063a969c-ebc4-49dc-9853-e2e0974132fb" &&
  gnupg-import &&
  aws-cli-init --aws-access-key-id "AKIAJYGTH5EGV54AOYUA" --region "us-east-1" --output "json" &&
  if [ ! -d homebank ]
  then
    decrypt-from-s3 --bucket "${BUCKET}" --destination "homebank" &&
      true
  fi &&
  homebank &&
  encrypt-to-s3 --bucket "${BUCKET}" --source "homebank" &&
  true
