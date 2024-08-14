#!/bin/sh
set -e

echo "=> Deleting sidekiq.pid file... "
if [ -f /app/tmp/pids/sidekiq.pid ]; then
  rm -f /app/tmp/pids/sidekiq.pid
fi

echo "=> Starting Sidekiq"
bundle exec sidekiq -C config/sidekiq.yml
