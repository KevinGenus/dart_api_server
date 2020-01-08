# Api
A basic Aqueduct api server with OAuth 2.0.

## Setup

### Add environment variables

1. Update `config.yaml`:
```
  database:
    host: $APP_DATABASE_HOST
    port: $APP_DATABASE_HOST_PORT
    username: $APP_DATABASE_USER
    password: $APP_DATABASE_USER_PASSWORD
    databaseName: $APP_DATABASE_NAME
```

2. Update `config.src.yaml`:
```
  database:
    host: $TEST_DATABASE_HOST
    port: $TEST_DATABASE_HOST_PORT
    username: $TEST_DATABASE_USER
    password: $TEST_DATABASE_USER_PASSWORD
    databaseName: $TEST_DATABASE_NAME
```

## Running Locally
In the root directory run `aqueduct serve` from command line or configure `bin/main.dart` in the IDE.

## Running Tests
In the root directory run `pub run test`.

## Authentication
This boiler plate instantiates an AuthServe. After starting the server:

1. Issue a registration request:
`curl -X POST http://localhost:8888/register -H 'Content-Type: application/json' -d '{"username":"kevingenus", "password":"password"}'`

2. Add a public OAuth 2.0 client:
`aqueduct auth add-client --id com.kevingenus.dev --connect postgres://db_user:password@localhost:5432/db_name`

3. Obtain an access token:
`curl -X POST http://localhost:8888/auth/token -H 'Authorization: Basic Y29tLmtldmluZ2VudXMuZGV2Og==' -H 'Content-Type: application/x-www-form-urlencoded' -d 'username=kevingenus&password=password&grant_type=password'`

4. On success you will receive the following response:
{"access_token":"dJO8nnAE0jQSfj71hxe9JGf2w8UYy5En","token_type":"bearer","expires_in":86399}

5. Include your access token against protected routes using a bearer authorization header:
`curl -X GET http://localhost:8888/profiles -H 'Authorization: Bearer dJO8nnAE0jQSfj71hxe9JGf2w8UYy5En'`
