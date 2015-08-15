#!/bin/sh

### BEGIN INIT INFO
# Provides:          nginx
# Required-Start:    $local_fs $remote_fs
# Required-Stop:     $local_fs $remote_fs
# Default-Start:     2 3 4 5
# Default-Stop:      S 0 1 6
# Short-Description: nginx initscript
# Description:       nginx
### END INIT INFO

# Source function library.
. /etc/rc.d/init.d/functions

# Source networking configuration.
. /etc/sysconfig/network

# Check that networking is up.
[ "$NETWORKING" = "no" ] && exit 0

nginx="/usr/local/sbin/nginx"
prog=$(basename $nginx)

NGINX_CONF_FILE="/etc/nginx/nginx.conf"

lockfile=/var/lock/subsys/nginx

start() {
	[ -x $nginx ] || exit 5
	[ -f $NGINX_CONF_FILE ] || exit 6
	echo -n $"Starting $prog: "
	daemon $nginx -c $NGINX_CONF_FILE
	retval=$?
	echo
	[ $retval -eq 0 ] && touch $lockfile
	return $retval
}

stop() {
	echo -n $"Stopping $prog: "
	killproc $prog -QUIT
	retval=$?
	echo
	[ $retval -eq 0 ] && rm -f $lockfile
	return $retval
}

restart() {
	configtest || return $?
	stop
	start
}

reload() {
	configtest || return $?
	echo -n $"Reloading $prog: "
	killproc $nginx -HUP
	RETVAL=$?
	echo
}

force_reload() {
	restart
}

configtest() {
  $nginx -t -c $NGINX_CONF_FILE
}

rh_status() {
	status $prog
}

rh_status_q() {
	rh_status >/dev/null 2>&1
}

case "$1" in
	start)
		rh_status_q && exit 0
		$1
		;;
	stop)
		rh_status_q || exit 0
		$1
		;;
	restart|configtest)
		$1
		;;
	reload)
		rh_status_q || exit 7
		$1
		;;
	force-reload)
		force_reload
		;;
	status)
		rh_status
		;;
	condrestart|try-restart)
		rh_status_q || exit 0
			;;
	*)
		echo $"Usage: $0 {start|stop|status|restart|condrestart|try-restart|reload|force-reload|configtest}"
		exit 2
esac