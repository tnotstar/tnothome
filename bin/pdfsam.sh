#!/bin/sh

# resolve links ala http://svn.apache.org/repos/asf/tomcat/trunk/bin/catalina.sh
CMDPATH="$0"
while [ -h "$CMDPATH" ]; do
    entry=$(ls -ld "$CMDPATH" 2> /dev/null)
    link=$(expr "$entry" : '.*-> \(.*\)$' 2> /dev/null)
    if expr "$link" : '/.*' 2> /dev/null 1>&2; then
        CMDPATH="$link"
    else
        CMDPATH=$(dirname "$CMDPATH")/"$link"
    fi
done
CMDNAME=$(basename "$CMDPATH" .sh)
CMDBASE=$(dirname "$CMDPATH")
CMDROOT=$(dirname "$CMDBASE")

# find pdfsam .jar file
CMDJAR=$(ls -1 $CMDROOT/opt/$CMDNAME/$CMDNAME*.jar 2> /dev/null)
if [ ! -r "$CMDJAR" ]; then
    echo "Fatal: the .jar file '$CMDJAR' not found."
    exit 1
fi

# check for java command
if [ -z "$JAVA" ]; then
    if [ -z "$JAVA_HOME" ]; then
        JAVA="java"
    else
        JAVA="$JAVA_HOME/bin/java"
    fi
fi

# check for java options
if [ -z "$JAVA_OPTS" ]; then
    JAVA_OPTS="-Xmx256m"
else
    JAVA_OPTS="$JAVA_OPTS -Xmx256m"
fi

# execute jvm in the foreground
exec "$JAVA" $JAVA_OPTS -classpath "$CMDJAR" org.pdfsam.guiclient.GuiClient "$@"

# EOF
