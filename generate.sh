#! /bin/bash

OPENAPI_GENERATOR_URL="${OPENAPI_GENERATOR_URL:-http://api.openapi-generator.tech}"
ASSISTED_SERVICE_VERSION="${ASSISTED_SERVICE_VERSION:-master}"
CLIENT="${CLIENT:-python-legacy}"
SPEC_FIELD=${SPEC_FIELD:-openAPIUrl}

[ "${OPENAPI_GENERATOR_URL}" != "https://generator.swagger.io" ] || SPEC_FIELD="swaggerUrl" CLIENT="${CLIENT/-legacy/}"

CLIENT_DIR="${CLIENT}-client"
CLIENT_FILENAME="${CLIENT_DIR}.zip"

ASSISTED_SERVICE_DIR="assisted-service-client-${CLIENT}-${ASSISTED_SERVICE_VERSION/v/}"

PACKAGE_VERSION=${ASSISTED_SERVICE_VERSION}
[ "${PACKAGE_VERSION}" != "master" ] || PACKAGE_VERSION="0.0.0"

echo "Generating the '${CLIENT}' client"
OPENAPI_DOWNLOAD_URL=$(curl -s -H "Content-Type: application/json" -X "POST" -d "{
  \"${SPEC_FIELD}\": \"https://raw.githubusercontent.com/openshift/assisted-service/${ASSISTED_SERVICE_VERSION}/swagger.yaml\",
  \"options\": {
      \"packageName\": \"assisted_service_client\",
      \"packageUrl\": \"https://github.com/openshift/assisted-service\",
      \"packageVersion\": \"${PACKAGE_VERSION}\",
      \"projectName\": \"assisted-service-client\"
  }
}" "${OPENAPI_GENERATOR_URL}/api/gen/clients/${CLIENT}" | jq -r .link)

echo "Downloading the '${CLIENT}' client"
curl -s -o "${CLIENT_FILENAME}" "${OPENAPI_DOWNLOAD_URL}"

echo "Unpacking the and updating the '${CLIENT}' client"
unzip -qq "${CLIENT_FILENAME}"
rm -rf "${ASSISTED_SERVICE_DIR}"
mv "${CLIENT_DIR}" "${ASSISTED_SERVICE_DIR}"
rm -f "${CLIENT_FILENAME}"

