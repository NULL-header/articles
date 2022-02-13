#!/bin/bash

if [ -z "$BRANCHES_TO_SKIP" ]; then
  BRANCHES_TO_SKIP=(master release)
fi

branch_name=`git symbolic-ref --short HEAD -q`

is_skipped=`echo -n "${BRANCHES_TO_SKIP[@]}" | grep -c "$branch_name"`

# pass when rebase or in the master or release branch
if [ -z "$branch_name" ] || [[ is_skipped -ne 0 ]]; then
  return 0
fi

issue=`echo -n $branch_name | sed -r "s:^.*(#[0-9]+).*$:\1:"`
cat $1 | sed -e /^\#/d | sed -r "s/(.*)?( #.*)/\1/g" \
  | sed "$ s/$/ $issue/" | xargs -0 -I{} echo -en {} >$1
