#! /bin/bash

set -x -e

OPENAPI_GENERATOR_URL="${OPENAPI_GENERATOR_URL:-http://api.openapi-generator.tech}"
ASSISTED_SERVICE_VERSION="${ASSISTED_SERVICE_VERSION:-master}"
CLIENT="${CLIENT:-python-legacy}"
SPEC_FIELD=${SPEC_FIELD:-openAPIUrl}

[ "${OPENAPI_GENERATOR_URL}" != "https://generator.swagger.io" ] || SPEC_FIELD="swaggerUrl" CLIENT="python"

CLIENT_DIR="${CLIENT}-client"
CLIENT_FILENAME="${CLIENT_DIR}.zip"

ASSISTED_SERVICE_DIR="assisted-service-client-python-${ASSISTED_SERVICE_VERSION/v/}"

PACKAGE_VERSION=${ASSISTED_SERVICE_VERSION}
[ "${PACKAGE_VERSION}" != "master" ] || PACKAGE_VERSION="0.0.0"

echo "Generating the Assisted Service API Python client"
OPENAPI_DOWNLOAD_URL=$(curl -s -H "Content-Type: application/json" -X "POST" -d "{
  \"${SPEC_FIELD}\": \"https://raw.githubusercontent.com/openshift/assisted-service/${ASSISTED_SERVICE_VERSION}/swagger.yaml\",
  \"options\": {
      \"generateSourceCodeOnly\": \"false\",
      \"hideGenerationTimestamp\": \"true\",
      \"library\": \"urllib3\",
      \"packageName\": \"assisted_service_client\",
      \"packageUrl\": \"https://github.com/openshift/assisted-service\",
      \"packageVersion\": \"${PACKAGE_VERSION}\",
      \"projectName\": \"assisted-service-client\",
      \"sortParamsByRequiredFlag\": \"true\",
      \"useNose\": \"false\"
  }
}" "${OPENAPI_GENERATOR_URL}/api/gen/clients/${CLIENT}" | jq -r .link)

echo "Downloading the Assisted Service API Python client"
curl -s -o "${CLIENT_FILENAME}" "${OPENAPI_DOWNLOAD_URL}"

echo "Unpacking the Assisted Service API Python client"
unzip -qq "${CLIENT_FILENAME}"

echo "Cleaning"
rm -rf "${ASSISTED_SERVICE_DIR}"
mv "${CLIENT_DIR}" "${ASSISTED_SERVICE_DIR}"
rm -f "${CLIENT_FILENAME}"

