## Assisted Installer API Python Client Generator

Scripts to generate the python client for the Assisted Service API (https://github.com/openshift/assisted-service).

Requirements:
- curl
- jq
- docker/podman container runtime (optional)

The command below will use the online generator found at http://api.openapi-generator.tech by default.
```
# Generate the python client from the master branch
./generate.sh

# Generate the python client for a specific version
ASSISTED_SERVICE_VERSION=v1.0.19.2 ./generate.sh

# Use the online swagger generator service
OPENAPI_GENERATOR_URL=https://generator.swagger.io ./generate.sh
```

It's also possible use a local generator by running the "generate-from-local-container.sh" script.
A container runtime (docker or podman) is needed in this case.
```
# Use docker to run the container
./generate-from-local-container.sh

# Use podman to run the container
CONTAINER_RUNTIME_COMMAND=podman ./generate-from-local-container.sh

# Map a different port to the container (default: 8888)
OPENAPI_GENERATOR_PORT=8080 ./generate-from-local-container.sh

# Use a different generator image (default: openapitools/openapi-generator-online)
OPENAPI_GENERATOR_IMAGE=swaggerapi/swagger-generator ./generate-from-local-container.sh
```
