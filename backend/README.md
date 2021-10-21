Simple sinatra app for sending slack notification.
Endpoint with slack notification(`/send-notification`) is checking request for presence of header `X-Secret-Header` with proper value that is set by `BACKEND_SECRET_KEY` env variable.

App envs are listed in `.env.example`.

### To get this application working locally
    $ bundle install
    $ bundle exec rackup

### Docker way

Use `Makefile`

```
build                          Docker build
run                            Docker run
```
