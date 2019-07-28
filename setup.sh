#!/bin/bash
# Copyright (C) 2019 baalajimaestro
#
# Licensed under the Raphielscape Public License, Version 1.b (the "License");
# you may not use this file except in compliance with the License.
#

echo "***Build Bot***"
echo $TELEGRAM_TOKEN >/tmp/tg_token
echo $TELEGRAM_CHAT >/tmp/tg_chat
echo $GITHUB_TOKEN >/tmp/gh_token
echo $DRONE_BUILD_NUMBER >/tmp/build_no
chmod +x /home/vsts/work/1/s/telegram
chmod +x /home/vsts/work/1/s/github-release

sudo bash -c "bash build.sh"
