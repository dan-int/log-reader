# LogReader

A Live Demo of this app is deployed at https://orange-sticky-iceblueredtopzebra.gigalixirapp.com/

# Code Walkthrough & Explanation

Technologies Used:
  * Elixir
  * Phoenix
  * Phoenix LiveView

I chose to utilize Elixir because of two main things:
  * Composability of functions while parsing lines in the log file
  * Phoenix LiveView fits this usecase
    * LiveView allows us to have great UI reactivity while staying in one technology
    * A downside of LiveView is that it requires the user to always be online. We don't have an offline requirement for this app so this concern is not very relevant.

The first part of this application is the [Mix Task](https://github.com/dan-int/log-reader/blob/master/lib/mix/tasks/etl.file.ex) that you would run to process a file into the application. In this task, we read the file into a stream and process it line by line.

We parse each line in the [Log model](https://github.com/dan-int/log-reader/blob/master/lib/log_reader/log.ex) and pull out relevant data like `uuid`, `route`, `duration`, etc... and persist it to a PostgreSQL database.

Inside this model, we have a set of functions for insights on the data such as "Most popular routes", "Most popular methods", etc... The most interesting of which is the [Slowest route insight](https://github.com/dan-int/log-reader/blob/master/lib/log_reader/log.ex#L74). This is the most complex query we have because we get the slowest log line by querying for the max `duration`, however, that line doesn't have the `route`, so we join it against the same table on `uuid` to get the log that contains the corresponding `route`.

These are then used in our LiveView ui components. The relevant files to read are:
  * [index.html](https://github.com/dan-int/log-reader/blob/master/lib/log_reader_web/templates/page/index.html.eex)
  * [insights pane](https://github.com/dan-int/log-reader/blob/master/lib/log_reader_web/live/insights_live.ex)
  * [browse pane](https://github.com/dan-int/log-reader/blob/master/lib/log_reader_web/live/browse_live.ex)

Inside the "insights pane", we have a set of elements that show data such as "Most popular routes", "Most popular methods", etc...

Inside the "browse pane", we initially render the first 100 log files and provide a search bar. Whenever a user types something in the bar, we perform a search and render the results automatically.

# Installation & Running

You'll need the following technologies installed:
```
erlang 22.1.4
elixir 1.9.4
nodejs 12.1.0
```

These are defined in the `.tool-versions` file. I suggest using [asdf](https://asdf-vm.com/#/core-manage-asdf-vm) to help manage these versions. It's kind of like RVM or NVM, but it can manage your whole language stack.

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
