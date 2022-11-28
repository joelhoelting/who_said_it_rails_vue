# Who Said It? (Backend)

Rails API-only backend for the [Vue.js frontend](https://github.com/joelhoelting/who_said_it_v2_frontend) of Who Said It? The application uses PostgreSQL for development and production. Custom authentication uses Bcrypt and JSON Web Tokens. Production mailer uses AWS Simple Email Service via the [AWS SDK for Rails](https://github.com/aws/aws-sdk-rails). Authentication in users controller uses [reCAPTCHA v3](https://developers.google.com/recaptcha/docs/v3) by sending a token from the frontend and then validating the token on the backend. 

# Setup (Development and Production)

## Database:

This application uses PostgreSQL and requires three databases (test, development and production). Either create the databases manually or create/alter a user with `CREATEDB` permissions in order to create the databases on the fly. The application also uses a Docker Postgres image in order to avoid database setup (see below).

username: postgres
 
test: `who_said_it_v2_test`  
development: `who_said_it_v2_development`  
production: `who_said_it_v2_production`

## Credentials:

Credentials are used throughout the application and come from `config/credentials.yml.enc` and a skeleton template can be be found in `config/credentials.skeleton.yml`. 

`config/master.key` and `config/credentials.yml.enc` must exist prior to running the application. 
- Delete `config/credentials.yml.enc`
- Run `EDITOR=vim rails credentials:edit` to create a new credentials file using the skeleton template found in `config/credentials.skeleton.yml`.

## Run

The normal way (once database and credentials have been set up):

Development: 

- `rails db:setup`
- `rails s`

Docker (Development/Production):

Pass in an environment variable for the postgres database password that will be used in `docker-compose.yml` and `docker-compose.production.yml`. This password should match the database password in the rails credentials file. 

For production, `docker-compose.production.yml` will setup an NGINX proxy on the host with an SSL certificate. Any domain references need to be updated in `nginx.production.conf` and `sudo ./init-letsencrypt.sh`. After running the other Docker commands run `sudo ./init-letsencrypt.sh` in order to replace the stub SSL certs with valid certificates.

Development:

- `POSTGRES_PASSWORD=<postgres_password> docker-compose up -d --build`
- `docker-compose run --rm app rails db:setup`

Production:

- `POSTGRES_PASSWORD=uWEmOIoqQuhDgsUpfOWeoEXBpDNo docker-compose -f docker-compose.production.yml up -d --build`
- `RAILS_ENV=production docker-compose -f docker-compose.production.yml run --rm app rails db:setup`
- `sudo ./init-letsencrypt.sh`

 ## Tests

 There are Rspec unit tests for models and requests. You can run these tests normally or with Docker.

 - `rspec`
 - `docker-compose run --rm app rspec`
