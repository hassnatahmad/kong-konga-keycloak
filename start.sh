docker-compose build kong
docker-compose up -d kong-db
docker-compose run --rm kong kong migrations bootstrap
docker-compose up -d kong
curl -s http://localhost:8001 | jq .plugins.available_on_server.oidc
docker-compose up -d konga
sleep 2m
curl -s -X POST http://localhost:8001/services -d name=mock-service -d url=http://mockbin.org/request | python -mjson.tool
curl -s -X POST http://localhost:8001/services/0718bce4-7e83-40c4-9e10-06ebdaf61be3/routes -d "paths[]=/mock" | python -mjson.tool
curl -s http://localhost:8000/mock
docker-compose up -d keycloak-db
curl -s -X POST http://localhost:8001/plugins -d name=oidc -d config.client_id=kong -d config.client_secret=3945b1eb-036f-462e-92a1-15dcabb07cc8 -d config.bearer_only=yes -d config.realm=experimental -d config.introspection_endpoint=http://192.168.1.72:8180/auth/realms/experimental/protocol/openid-connect/token/introspect -d config.discovery=http://192.168.1.72:8180/auth/realms/experimental/.well-known/openid-configuration | python -mjson.tool
curl "http://192.168.1.72:8000/mock" -H "Accept: application/json" -I

curl --location --request POST 'http://192.168.1.72:8180/auth/realms/experimental/protocol/openid-connect/token' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'username=demouser' \
--data-urlencode 'password=password' \
--data-urlencode 'grant_type=password' \
--data-urlencode 'client_id=myapp'

curl --location --request GET 'http://192.168.1.72:8000/mock' \
--header 'Authorization: Bearer jXRRhT6fhg'
