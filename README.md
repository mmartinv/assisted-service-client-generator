## Assisted Installer API Client Generator

Scripts to generate the client code for the Assisted Service API (https://github.com/openshift/assisted-service).

Requirements:
- curl
- jq
- unzip
- docker/podman container runtime (optional)


The ```generator.sh``` script, by default, uses the online generator found at http://api.openapi-generator.tech to create 
the python client for the latest version of the Assisted Service API within the ```assisted-service-client-python-legacy-master``` directory.
```
./generate.sh
```

It's also possible to generate the python client for a specific verson:
```
ASSISTED_SERVICE_VERSION=v1.0.19.2 ./generate.sh
```

Or use the swagger online generator service instead:
```
OPENAPI_GENERATOR_URL=https://generator.swagger.io ./generate.sh
```

By default the python client is generated but it's also possible to generate any of the supported clients:
```
CLIENT=javascript ./generate.sh
```

The full list of supported clients can be retrieved with the following command:
```
# for the OpenAPI generator
curl -s http://api.openapi-generator.tech/api/gen/clients | jq -r '.[] | "\(.)"'


# for the Swagger generator
curl -s https://generator.swagger.io/api/gen/clients | jq -r '.[] | "\(.)"'
```

It's possible to run a local generator instead of using the online generator by running the ```generate-from-local-container.sh``` script.
A container runtime (docker or podman) is needed in this case.

The default execution uses docker to run the **openapitools/openapi-generator-online** container image and maps the **8888** port to the container
```
./generate-from-local-container.sh
```

To use podman instead of docker:
```
CONTAINER_RUNTIME_COMMAND=podman ./generate-from-local-container.sh
```

To change the local port mapped to the container:
```
OPENAPI_GENERATOR_PORT=8080 ./generate-from-local-container.sh
```

It's also possible to use the swagger generator image:
```
OPENAPI_GENERATOR_IMAGE=swaggerapi/swagger-generator ./generate-from-local-container.sh
```

All the commands above will create a new directory ```assisted-service-client-${CLIENT}-${ASSISTED_SERVICE_VERSION}```
containing the client code, e.g.: 
```
ASSISTED_SERVICE_VERSION=v1.0.19.2
CLIENT=python-legacy
./generate.sh
cd assisted-service-client-${CLIENT}-${ASSISTED_SERVICE_VERSION}
python setup.py install --user
```

To generate all the possible OpenAPI clients:
```
OPENAPI_CLIENTS_URL="http://api.openapi-generator.tech/api/gen/clients"
for CLIENT in $(curl -s "${OPENAPI_CLIENTS_URL}" | jq -r '.[] | "\(.)"') ; do
    CLIENT=${CLIENT} ./generate.sh;
done
```

To generate all the possible Swagger clients:
```
OPENAPI_CLIENTS_URL="https://generator.swagger.io/api/gen/clients"
for CLIENT in $(curl -s "${OPENAPI_CLIENTS_URL}" | jq -r '.[] | "\(.)"') ; do
    OPENAPI_GENERATOR_URL="https://generator.swagger.io" CLIENT=${CLIENT} ./generate.sh;
done
```

Using the local generator to do the same is slightly different:
```
OPENAPI_CLIENTS_URL="http://api.openapi-generator.tech/api/gen/clients"
CLIENTS=$(curl -s "${OPENAPI_CLIENTS_URL}" | jq -r '.[] | "\(.)"') ./generate-from-local-container.sh
```
