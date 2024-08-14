#!/bin/sh
set -e

echo "=> Deleting server.pid file... "
if [ -f /app/tmp/pids/server.pid ]; then
  rm -f /app/tmp/pids/server.pid
fi


echo "=> Run App "
bundle exec rails s -p ${PORT:-3000} -b 0.0.0.0
