#!/bin/sh

k run --restart=Never --image=busybox e2  -- /bin/sh -c 'i=0; while true; do echo "$i: $(date)"; i=$((i+1)); sleep 1; done'
