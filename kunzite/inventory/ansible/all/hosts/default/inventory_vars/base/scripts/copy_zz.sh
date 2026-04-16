#!/bin/bash
# created with
# cat zz.txt | gpg --symmetric --output ~/.zz.gpg
gpg --quiet --decrypt ~/.zz.gpg 2>/dev/null | tr -d '\n' | wl-copy

# clear clipboard after 15s
sleep 15 && wl-copy "" &
