# kryptopedia dashboard

a database sync server with big dreams

## Development setup

- install ruby, look at `.ruby_version` for the version i'm using. i recommend using something like `rbenv` to manage your rubies
- clone the repo and open this directory in your editor of choice (Jetbrains RubyMine works well)
- run `bundle install`
- get your credentials set up: run `EDITOR="code --wait" bin/rails credentials:edit` to open the credentials file in VS Code, and add the following:

```yaml
tba:
  key: # from https://www.thebluealliance.com/account
  webhook_secret: # also from tba's account page, if you want to bother with webhooks

secret_key_base: # random string of characters, can be generated with `bin/rails secret`

nexus:
  key: # from https://frc.nexus/api
```

(or skip this and ask dominic for the `development.key` file and put it in `config/credentials/`)

- run `bin/rails db:setup` to set up the database and run migrations
- run `bin/rails db:seed` to put in some useful sample data
- run `bin/rails server` to start the server! and i think thats it

## Deployment

abridged version for people with google

- its mostly the same. set up your production credentials file, with the same structure as before but with more. add these:

```yaml
smtp: # for email sending! hardcoded to Resend's service, theres stuff you'll need to modify for this to work probably
  password:

r2: # cloudflare storage for robot images, easily modifiable for other storage providers. see `config/storage.yml`
  endpoint:
  access_key_id:
  secret_access_key:
  bucket:

sentry:
  dsn: # optional, for error and metrics tracking with Sentry.
```

- set the `PARTIAL_DB_URL` environment variable to a postgres database url but without the username/password or db name
- make sure your `production.key` is either in `config/credentials/` or set in the `RAILS_MASTER_KEY` environment variable
- use the `Dockerfile` to build and deploy the docker container, then expose port 3000!

## webhook setup

you can point a webhook to `/webhooks/tba` to get some data to update automatically, in theory. TBA will want a verification code after you do this, which will be shown for an hour on `/webhooks`
