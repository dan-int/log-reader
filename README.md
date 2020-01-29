# LogReader

You'll need the following technologies installed:
```
erlang 22.1.4
elixir 1.9.4
nodejs 12.1.0
```

These are defined in the `.tool-versions` file. I suggest using [asdf](https://asdf-vm.com/#/core-manage-asdf-vm) to help manage these versions.

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
    * This assumes you have PostgreSQL set up with a username:password of `postgres:postgres`
  * Install Node.js dependencies with `cd assets && npm install`
  * Process a log file with `mix etl.file ./priv/log-files/sample.log`
    * You can point to any log file
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
