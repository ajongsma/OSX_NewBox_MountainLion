#!/usr/bin/env bash

# Ctrl-b      : the prefix that sends a keybinding to tmux instead of to the shell or program running in tmux.
# Ctrl-b c    : create a new window.
# Ctrl-b "    : split the window horizontally.
# Ctrl-b %    : split the window vertically.
# Ctrl-b s    : list sessions.
# Ctrl-b d    : detach a session.
# Ctrl-b [    : start copy.
# Ctrl-Space  : start selection.
# Ctrl-w      : copy text from selection.
# Ctrl-b ]    : paste.
# Ctrl-b w    : select from windows.
# Ctrl-b l    : last window.
# Ctrl-b n    : next window.
# Ctrl-b      : command mode.
# Ctrl-b <nr> : Change to tab <nr>

SOURCE="${BASH_SOURCE[0]}"
TMUX_CURRENT_DIR="$( dirname "$SOURCE" )"
while [ -h "$SOURCE" ]
do
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$TMUX_CURRENT_DIR/$SOURCE"
  TMUX_CURRENT_DIR="$( cd -P "$( dirname "$SOURCE"  )" && pwd )"
done
TMUX_CURRENT_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
unset SOURCE

TMUX_APP_PATH="/usr/local/share/spotweb"
TMUX_APP="spotweb_cycle.sh"
TMUX_SESSION="Spotweb"
TMUX_POWERLINE="false"
TMUX_PID_FILE=/tmp/spotweb.pid

command -v sh >/dev/null 2>&1 || { echo >&2 "[$(date)] SH required but it's not installed. Aborting."; exit 1; } && TMUX_SH=`command -v sh`
command -v tmux >/dev/null 2>&1 || { echo >&2 "[$(date)] Tmux required but it's not installed. Aborting."; exit 1; } && TMUX_CMD=`command -v tmux`
command -v nice >/dev/null 2>&1 || { echo >&2 "[$(date)] Nice required but it's not installed. Aborting."; exit 1; } && TMUX_NICE=`command -v nice`
command -v php >/dev/null 2>&1 || { echo >&2 "[$(date)] PHP required but it's not installed. Aborting."; exit 1; } && TMUX_PHP=`command -v php` || { TMUX_PHP=`command -v php`; }
command -v mysql >/dev/null 2>&1 || { echo >&2 "[$(date)] MySQL required but it's not installed. Aborting."; exit 1; } && TMUX_MYSQL=`command -v mysql`

if [[ $TMUX_POWERLINE == "true" ]]; then
  TMUX_CONF="$HOME/.tmux/conf/tmux_powerline.conf"
else
  TMUX_CONF="$HOME/.tmux/conf/tmux_bash.conf"
fi
if [ ! -f "$TMUX_CONF" ]; then
  echo "[$(date)] File $TMUX_CONF not found. Aborting..."
  exit 1
fi

#tmux list-sessions
if $TMUX_CMD -q has-session -t $TMUX_SESSION; then
  echo "[$(date)] Tmux session $TMUX_SESSION detected  - [OK]"
  #$TMUX_CMD attach-session -t $TMUX_SESSION
else
  echo "[$(date)] Tmux session $TMUX_SESSION not found. Spinning up..."

  if [ ! -f "$TMUX_PID_FILE" ]; then
    echo "[$(date)] Obsolete PID $TMUX_PID_FILE found, deleting"
    rm -f $TMUX_PID_FILE
    if [ $? -ne 0 ]; then
      echo "$0: Failed to remove file $TMUX_PID_FILE. Aborting."
      exit 1
    fi
  fi

  tmux start-server
  tmux -f $TMUX_CONF new-session -d -s $TMUX_SESSION -n $TMUX_SESSION
  if [ ! -z "$TMUX_PID_FILE" ]; then
    echo $$ > $TMUX_PID_FILE
  fi
  #echo $$

  # tmux attach-session -d -t Spotweb

  tmux select-pane -t 0
  tmux send-keys -t $TMUX_SESSION:0 "cd $TMUX_APP_PATH" C-m
  tmux send-keys -t $TMUX_SESSION:0 "clear" C-m
  tmux send-keys -t $TMUX_SESSION:0 "$TMUX_NICE -n 19 $TMUX_SH $TMUX_APP" C-m

  ## Create another pane
#  tmux splitw -v -p 12
#  tmux select-pane -t 1
#  tmux send-keys -t $TMUX_SESSION:0 "cd $TMUX_CURRENT_DIR" C-m
#  tmux send-keys -t $TMUX_SESSION:0 "$TMUX_SH tmux_process_monitor.sh 'tmux attach-session -d -t $TMUX_SESSION'" C-m

  ## Create extra tab
  #tmux new-window -t NewzNab:1 -n 'monitor' 'echo "Monitor ..."'

  ## Attach session
  tmux select-window -t $TMUX_SESSION:0
  tmux select-pane -t 0

  #tmux attach-session -d -t $TMUX_SESSION
fi
