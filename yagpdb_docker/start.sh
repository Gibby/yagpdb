#!/bin/sh

if [ "$GAUTH" != "false" ];then
  echo "$GAUTH" > "$GOOGLE_APPLICATION_CREDENTIALS"
fi

exec "$@"
