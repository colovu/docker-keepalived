#!/bin/bash
# 重新启动 Keepalived 服务

. /usr/local/bin/appcommon.sh			# 应用专用函数库

eval "$(app_env)"

kill -HUP $(< "${APP_PID_FILE}")
