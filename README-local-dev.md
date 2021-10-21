# Local development with Docker Compose


For more information about running frontend and backend separately please look at README.md inside their directories.


## How to run whole app - frontend & backend? - Docker Compose Way

We will use 2 domains

- `localhost` - for frontend
- `api.localhost` - for backend

### 1. Create `.env` file with proper values and `export` them
```bash
cp .env.example .env
# edit .env
```

Example `.env`
```bash
BACKEND_SECRET_KEY=razdwatrzy
API_URL=api.localhost
SLACK_WEBHOOK_URL= # empty for local testing
PROJECT_NAME=local
PROJECT_ENV=test
CORS_ALLOW_ORIGIN=https://localhost
```

### 2. Edit you `/etc/hosts` file

Regarding `docker-compose.yml`, frontend application is available under domain `localhost` and backend application under domain `api.localhost`.
Therefore, You need to make your workstation to resolve this domains in right way. `localhost` is set by default to point your workstation, but `api.localhost` not.

You have to add line:
```
127.0.0.1 api.localhost
```
into your `/etc/hosts` (use `sudo`).

For more information click [here](https://en.wikipedia.org/wiki/Hosts_(file))

### 3. Prepare SSL certificates for localhost and api.localhost

We will use [mkcert](https://github.com/FiloSottile/mkcert)

- install mkcert
    ```bash
    brew install mkcert
    brew install nss # only if you use Firefox
    # then
    mkcert -install
    # restart browsers
    ```
- generate certificates
    ```bash
    mkcert localhost api.localhost
    ```
- move them into `certs/` directory, rename and create symlinks for api.localhost
    ```bash
    mkdir certs/
    mv localhost+1.pem certs/localhost.crt
    mv localhost+1-key.pem certs/localhost.key
    cd certs/
    ln -s localhost.crt api.localhost.crt
    ln -s localhost.key api.localhost.key
    ```
    nginx-proxy will use them for serving HTTPS traffic


### 4. Build images and run it

```
docker-compose up --build
```

### 5. Open https://localhost in web browser
