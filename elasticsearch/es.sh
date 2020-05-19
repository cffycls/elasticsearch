#!/bin/bash
#
# /etc/init.d/elasticsearch -- startup script for Elasticsearch
#
### BEGIN INIT INFO
# Provides:          elasticsearch
# Required-Start:    $network $remote_fs $named
# Required-Stop:     $network $remote_fs $named
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Starts elasticsearch
# Description:       Starts elasticsearch using start-stop-daemon
### END INIT INFO

PATH=/bin:/usr/bin:/sbin:/usr/sbin
NAME=elasticsearch
DESC="Elasticsearch Server"
DEFAULT=/etc/default/$NAME

if [ `id -u` -ne 0 ]; then
	echo "You need root privileges to run this script"
	exit 1
fi


. /lib/lsb/init-functions

if [ -r /etc/default/rcS ]; then
	. /etc/default/rcS
fi


# The following variables can be overwritten in $DEFAULT

# Run Elasticsearch as this user ID and group ID
ES_USER=elasticsearch
ES_GROUP=elasticsearch

# Directory where the Elasticsearch binary distribution resides
ES_HOME=/usr/share/$NAME

# Additional Java OPTS
#ES_JAVA_OPTS=

# Maximum number of open files
MAX_OPEN_FILES=65536

# Maximum amount of locked memory
#MAX_LOCKED_MEMORY=

# Elasticsearch log directory
LOG_DIR=/var/log/$NAME

# Elasticsearch data directory
DATA_DIR=/var/lib/$NAME

# Elasticsearch configuration directory
CONF_DIR=/etc/$NAME

# Maximum number of VMA (Virtual Memory Areas) a process can own
MAX_MAP_COUNT=262144

# Elasticsearch PID file directory
PID_DIR="/var/run/elasticsearch"

# End of variables that can be overwritten in $DEFAULT

# overwrite settings from default file
if [ -f "$DEFAULT" ]; then
	. "$DEFAULT"
fi

if [ "$ES_USER" != "elasticsearch" ] || [ "$ES_GROUP" != "elasticsearch" ]; then
    echo "WARNING: ES_USER and ES_GROUP are deprecated and will be removed in the next major version of Elasticsearch, got: [$ES_USER:$ES_GROUP]"
fi

# CONF_FILE setting was removed
if [ ! -z "$CONF_FILE" ]; then
    echo "CONF_FILE setting is no longer supported. elasticsearch.yml must be placed in the config directory and cannot be renamed."
    exit 1
fi

# Define other required variables
PID_FILE="$PID_DIR/$NAME.pid"
DAEMON=$ES_HOME/bin/elasticsearch
DAEMON_OPTS="-d -p $PID_FILE -Edefault.path.logs=$LOG_DIR -Edefault.path.data=$DATA_DIR -Edefault.path.conf=$CONF_DIR"

export ES_JAVA_OPTS
export JAVA_HOME
export ES_INCLUDE
export ES_JVM_OPTIONS

# export unsupported variables so bin/elasticsearch can reject them and inform the user these are unsupported
if test -n "$ES_MIN_MEM"; then export ES_MIN_MEM; fi
if test -n "$ES_MAX_MEM"; then export ES_MAX_MEM; fi
if test -n "$ES_HEAP_SIZE"; then export ES_HEAP_SIZE; fi
if test -n "$ES_HEAP_NEWSIZE"; then export ES_HEAP_NEWSIZE; fi
if test -n "$ES_DIRECT_SIZE"; then export ES_DIRECT_SIZE; fi
if test -n "$ES_USE_IPV4"; then export ES_USE_IPV4; fi
if test -n "$ES_GC_OPTS"; then export ES_GC_OPTS; fi
if test -n "$ES_GC_LOG_FILE"; then export ES_GC_LOG_FILE; fi

if [ ! -x "$DAEMON" ]; then
	echo "The elasticsearch startup script does not exists or it is not executable, tried: $DAEMON"
	exit 1
fi

checkJava() {
	if [ -x "$JAVA_HOME/bin/java" ]; then
		JAVA="$JAVA_HOME/bin/java"
	else
		JAVA=`which java`
	fi

	if [ ! -x "$JAVA" ]; then
		echo "Could not find any executable java binary. Please install java in your PATH or set JAVA_HOME"
		exit 1
	fi
}

case "$1" in
  start)
	checkJava

	log_daemon_msg "Starting $DESC"

	pid=`pidofproc -p $PID_FILE elasticsearch`
	if [ -n "$pid" ] ; then
		log_begin_msg "Already running."
		log_end_msg 0
		exit 0
	fi

	# Ensure that the PID_DIR exists (it is cleaned at OS startup time)
	if [ -n "$PID_DIR" ] && [ ! -e "$PID_DIR" ]; then
		mkdir -p "$PID_DIR" && chown "$ES_USER":"$ES_GROUP" "$PID_DIR"
	fi
	if [ -n "$PID_FILE" ] && [ ! -e "$PID_FILE" ]; then
		touch "$PID_FILE" && chown "$ES_USER":"$ES_GROUP" "$PID_FILE"
	fi

	if [ -n "$MAX_OPEN_FILES" ]; then
		ulimit -n $MAX_OPEN_FILES
	fi

	if [ -n "$MAX_LOCKED_MEMORY" ]; then
		ulimit -l $MAX_LOCKED_MEMORY
	fi

	if [ -n "$MAX_MAP_COUNT" -a -f /proc/sys/vm/max_map_count -a "$MAX_MAP_COUNT" -gt $(cat /proc/sys/vm/max_map_count) ]; then
		sysctl -q -w vm.max_map_count=$MAX_MAP_COUNT
	fi

	# Start Daemon
	#start-stop-daemon -d $ES_HOME --start --user "$ES_USER" -c "$ES_USER" --pidfile "$PID_FILE" --exec $DAEMON -- $DAEMON_OPTS
	start-stop-daemon -d $ES_HOME --start --user "root" -c "root" --pidfile "$PID_FILE" --exec $DAEMON -- $DAEMON_OPTS
	return=$?
	if [ $return -eq 0 ]; then
		i=0
		timeout=10
		# Wait for the process to be properly started before exiting
		until { kill -0 `cat "$PID_FILE"`; } >/dev/null 2>&1
		do
			sleep 1
			i=$(($i + 1))
			if [ $i -gt $timeout ]; then
				log_end_msg 1
				exit 1
			fi
		done
	fi
	log_end_msg $return
	exit $return
	;;
  stop)
	log_daemon_msg "Stopping $DESC"

	if [ -f "$PID_FILE" ]; then
		start-stop-daemon --stop --pidfile "$PID_FILE" \
			--user "$ES_USER" \
			--quiet \
			--retry forever/TERM/20 > /dev/null
		if [ $? -eq 1 ]; then
			log_progress_msg "$DESC is not running but pid file exists, cleaning up"
		elif [ $? -eq 3 ]; then
			PID="`cat $PID_FILE`"
			log_failure_msg "Failed to stop $DESC (pid $PID)"
			exit 1
		fi
		rm -f "$PID_FILE"
	else
		log_progress_msg "(not running)"
	fi
	log_end_msg 0
	;;
  status)
	status_of_proc -p $PID_FILE elasticsearch elasticsearch && exit 0 || exit $?
	;;
  restart|force-reload)
	if [ -f "$PID_FILE" ]; then
		$0 stop
	fi
	$0 start
	;;
  *)
	log_success_msg "Usage: $0 {start|stop|restart|force-reload|status}"
	exit 1
	;;
esac

exit 0
