#!/usr/bin/env bash

export EXTEND='cron-bundle@1.0.0-next.3'

function bundle::crontab_name() {
  hostname -s
}
