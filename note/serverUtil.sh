  #!/bin/bash

    psid=0
    serverInfo=$2

    serverInfo=$2

    case "$2" in
       'center')
     serverInfo=certify/certifyServer.start.cfg
     ;;
       'db')
     serverInfo=game/dbServer.start.cfg
     ;;
       'corps')
      serverInfo=corps/corpsServer.start.cfg
     ;;
       'slg')
     serverInfo=newSlg/slgServer.start.cfg
     ;;
       'logic')
     serverInfo=game/logicServer.start.cfg
     ;;
    esac

    checkpid() {
       javaps=`jps -l -m | grep $serverInfo`

       if [ -n "$javaps" ]; then
      psid=`echo $javaps | awk '{print $1}'`
       else
      psid=0
       fi
    }

    info() {
       checkpid
       javaps=`jps -m -l | grep $serverInfo`
       echo "System Information:"
       echo "****************************"
       echo $javaps
       echo pid = $psid
       echo "****************************"
    }

    start() {
       checkpid

       if [ $psid -ne 0 ]; then
      echo "================================>"
      echo "warn: $serverInfo already started! (pid=$psid)"
      echo "================================>"
       else
      echo -n "Starting $serverInfo ..."
      startserver
      checkpid
      if [ $psid -ne 0 ]; then
     echo "(pid=$psid) [OK]"
      else
     echo "[Failed]"
      fi
       fi
    }

    startserver() {
    case "$serverInfo" in
       'certify/certifyServer.start.cfg')
    `sh centerServer2.sh`
       ;;
       'corps/corpsServer.start.cfg')
    `sh corpsServer2.sh`
       ;;
      'newSlg/slgServer.start.cfg')
    `sh slgServer2.sh`
       ;;
      'game/logicServer.start.cfg')
    `sh logicServer2.sh`
       ;;
      'game/dbServer.start.cfg')
       `sh dbServer2.sh`
       ;;
      'push/pushServer.start.cfg')
       `sh pushServer.sh`
       ;;
     *)
      echo "server info err"
    esac
    }


    stop() {
       checkpid

       if [ $psid -ne 0 ]; then
      echo -n "Stopping $serverInfo ...(pid=$psid) "
      su - $RUNNING_USER -c "kill -9 $psid"
      if [ $? -eq 0 ]; then
     echo "[OK]"
      else
     echo "[Failed]"
      fi

      checkpid
      if [ $psid -ne 0 ]; then
     stop
      fi
       else
      echo "================================"
      echo "warn: $serverInfo is not running"
      echo "================================"
       fi
    }

    case "$1" in
       'start')
     start
      ;;
       'stop')
     stop
      ;;
       'restart')
     stop
     start
     ;;
       'info')
     info
     ;;
      *)
     echo "Usage: $0 {start|stop|restart|status|info}"
     exit 1
    esac
    exit 0