# CEP on Rails

## Description

"CEP on Rails" is a REST API that returns address data based on the provided Brazilian Postal Code (CEP). It is designed considering high volume of access. The API features token-based authentication and associates the queried addresses with the requesting user.

## Requirements

- Ruby 3.2.0
- Rails 7.0.6
- PostgreSQL
- Redis
- Memcache

## Setting Up the Project

### Clone the Repository:

```sh
git clone git@github.com:thiswd/cep-on-rails.git
cd cep-on-rails
```

### Install Dependencies:

```sh
bundle install
```

### Setup Database:

```sh
rails db:create
rails db:migrate
```

### Running Seed Data:

```sh
rails db:seed
```

This will create a user with the following credentials:

- **Email:** jaiminho@correios.gov.br
- **Password:** tangamandapio

### Generate Secret Key for JWT:

Run the following command to generate a secret key and save it to the `.env` file:

```sh
rails generate jwt:secret_key
```

## Running the Project

### Using Docker:

```sh
docker-compose up --build
```

### Using the Terminal:
Start the Rails server:

```sh
rails s
```

Start Redis and Memcache using your preferred method.

## Running the Tests

To run the test suite, execute:

```sh
rspec .
```

## Main Tools and Gems
- Rails (Web Framework)
- PostgreSQL (Database)
- Puma (Web Server)
- Redis (In-Memory Data Store)
- Devise (Authentication)
- Devise JWT (JWT token for Devise)
- Rack CORS (Handling CORS)
- Rack Attack (Rate Limiting)
- Dalli (Memcached Client)

## API Rate Limiting
The API enforces a rate limit of 6 calls in 30 seconds to prevent abuse.

## Testing the API

### Generate JWT Token:
**POST Request to:**

```bash
http://localhost:3000/api/v1/sign_in
```

**Body:**

```json
{
  "api_v1_user": {
    "email": "jaiminho@correios.gov.br",
    "password": "tangamandapio"
  }
}
```

The token expires in five minutes.

### Create Address:
**POST Request to:**

```bash
http://localhost:3000/api/v1/users/:user_id/addresses
```

**Headers:**

```makefile
Authorization: Bearer <token>
```

**Body:**

```json
{
  "address": {
    "cep": "00000000"
  }
}
```

The data comes from [ViaCEP](https://viacep.com.br).
