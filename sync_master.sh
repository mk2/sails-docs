#!/bin/bash

master_added_files=`git diff origin/master --diff-filter=D --name-status | awk '{ print $2 }'`
master_deleted_files=`git diff origin/master --diff-filter=A --name-status | awk '$2 !~ /^_ja.*|^sync_master/ { print $2 }'`

# remove files
for file in ${master_deleted_files}; do
  echo "REMOVE: ${file}"
  rm ${file}
done

# create files
for file in ${master_added_files}; do
  echo "CREATE: ${file}"
  install -D /dev/null ${file}
done
