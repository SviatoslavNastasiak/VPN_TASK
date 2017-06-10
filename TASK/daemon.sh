#!/bin/bash

SRC=$(pwd)
CONFIG_PATH="${SRC}/OpenVPN/config_files/USA.ovpn"
PIDFILE="${SRC}/OpenVPN/ovpn.pid"
LOGFILE="${SRC}/OpenVPN/LOGFILE.log"

start() 
{
  if [ -f $PIDFILE ] && [ -s $PIDFILE ] && kill $(cat $PIDFILE); then
    echo 'Service already running' >&2
    return 1
  fi
  echo 'Starting service…' >&2
  sudo openvpn --config "$CONFIG_PATH" >> "$LOGFILE" &
  echo $! > "$PIDFILE"
}

stop() 
{
  if [ ! -f "$PIDFILE" ] || ! kill $(cat "$PIDFILE"); then
    echo 'Service not running' >&2
    return 1
  fi
  echo 'Stopping service…' >&2
  kill $(cat $PIDFILE) && rm -f "$PIDFILE"
  echo 'Service stopped' >&2
}

uninstall() 
{
  echo -n "Are you really sure you want to uninstall this service? That cannot be undone. [yes|No] "
  local SURE
  read SURE
  if [ "$SURE" = "yes" ]; then
    stop
    rm -f "$PIDFILE"
    echo "Notice: log file was not removed: $LOGFILE" >&2
  fi
}


case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  uninstall)
    uninstall
    ;;
  *)
    echo "Usage: $0 {start|stop|uninstall}"
esac