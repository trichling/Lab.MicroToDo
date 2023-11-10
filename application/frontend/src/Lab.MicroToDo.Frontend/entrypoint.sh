#!/usr/bin/env sh

set -eu

function join_by { local IFS="$1"; shift; echo "$*"; }

# Replace value of BLAZOR_ENVIRONMETN environment variable for nginx configuration
# This env var will be set through the kubernetes deployment
# This will add blazor-environment header to every call so blazor loads the correct appsettings.json
envsubst '${BLAZOR_ENVIRONMENT}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

# Look for all other environment variables from the deployment
vars=$(env | awk -F = '{print "$"$1}')
vars=$(join_by ' ' $vars)
echo "Found variables $vars"

# Replace all environment variables in the appsettings.json files
for file in /usr/share/nginx/html/wwwroot/*.json; do
  echo "Processing $file ...";

  cp $file $file.tmpl
  envsubst "$vars" < $file.tmpl > $file
  rm $file.tmpl
done

exec "$@"
