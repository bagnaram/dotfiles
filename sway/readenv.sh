#!/bin/bash
# Environment
while read -r l; do
    eval export $l
done < <(/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator)
