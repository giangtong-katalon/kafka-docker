#!/bin/bash -e

if [[ -z "$KAFKA_SERVER_CONFIG" ]]; then
    echo "ERROR: missing mandatory config: KAFKA_SERVER_CONFIG"
    exit 1
fi

create-topics.sh &
unset KAFKA_CREATE_TOPICS

echo "$KAFKA_SERVER_CONFIG" > "$KAFKA_HOME/config/kraft/server2.properties"

uuid=$($KAFKA_HOME/bin/kafka-storage.sh random-uuid)
"$KAFKA_HOME/bin/kafka-storage.sh" format -t $uuid -c "$KAFKA_HOME/config/kraft/server2.properties"

exec "$KAFKA_HOME/bin/kafka-server-start.sh" "$KAFKA_HOME/config/kraft/server2.properties"
