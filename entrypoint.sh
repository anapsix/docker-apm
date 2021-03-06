#!/usr/bin/env sh

set -euo pipefail

# Check if the the user has invoked the image with flags.
# eg. "apm-server -c apm-server.yml"
if [[ -z $1 ]] || [[ ${1:0:1} == '-' ]] ; then
  exec apm-server "$@"
else
  # They may be looking for a subcommand, like "apm-server setup".
  subcommands=$(apm-server help \
                  | awk 'BEGIN {RS=""; FS="\n"} /Available Commands:/' \
                  | awk '/^\s+/ {print $1}')

  # If we _did_ get a subcommand, pass it to apm-server.
  for subcommand in $subcommands; do
      if [[ $1 == $subcommand ]]; then
        exec apm-server "$@"
      fi
  done
fi

# If niether of those worked, then they have specified the binary they want, so
# just do exactly as they say.
exec "$@"