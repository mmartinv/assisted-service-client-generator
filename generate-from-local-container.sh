#!/usr/bin/env bash

CONTAINER_RUNTIME_COMMAND=${CONTAINER_RUNTIME_COMMAND:-docker}
OPENAPI_GENERATOR_HOST=${OPENAPI_GENERATOR_HOST:-localhost}
OPENAPI_GENERATOR_PORT=${OPENAPI_GENERATOR_PORT:-8888}
OPENAPI_GENERATOR_URL="http://${OPENAPI_GENERATOR_HOST}:${OPENAPI_GENERATOR_PORT}"
OPENAPI_GENERATOR_IMAGE=${OPENAPI_GENERATOR_IMAGE:-openapitools/openapi-generator-online}

if [ "${OPENAPI_GENERATOR_IMAGE/:*/}" == "swaggerapi/swagger-generator" ]; then
  SPEC_FIELD="swaggerUrl" CLIENTS="${CLIENTS:-python/}" GENERATOR_HOST=${OPENAPI_GENERATOR_URL}
else
  SPEC_FIELD="openAPIUrl" CLIENTS="${CLIENTS:-python-legacy}"
fi

echo "Starting the container."
CONTAINER=$(${CONTAINER_RUNTIME_COMMAND} run -d -e GENERATOR_HOST=${GENERATOR_HOST} -p ${OPENAPI_GENERATOR_PORT}:8080 ${OPENAPI_GENERATOR_IMAGE})

echo -n "Waiting for the service to be ready"
while true; do
  if curl -s "${OPENAPI_GENERATOR_URL}/api/gen/clients" &>/dev/null;
  then
    echo " done!"
    break
  fi
  sleep 1
  echo -n " ."
done

for CLIENT in ${CLIENTS}; do
  CLIENT=${CLIENT} SPEC_FIELD=${SPEC_FIELD} OPENAPI_GENERATOR_URL=${OPENAPI_GENERATOR_URL} ./generate.sh
done

echo "Removing the container."
${CONTAINER_RUNTIME_COMMAND} rm -f ${CONTAINER} &>/dev/null
