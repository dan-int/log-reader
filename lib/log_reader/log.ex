defmodule LogReader.Log do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias LogReader.Repo

  # Started GET "/" for 127.0.0.1 at 2016-03-30 15:58:41 -0400
  @started_regex ~r/Started\s(?<http_method>(GET)|(POST)|(PUT)|(PATCH)|(DELETE))\s\"(?<route>\S+)\".+at\s(?<timestamp>.+)/

  # Completed 200 OK in 388ms
  @completed_regex ~r/Completed\s(?<status_code>[0-9]+)\s.+\sin\s(?<duration>[0-9]+)+ms/

  schema "logs" do
    field :duration, :integer
    field :http_method, :string
    field :message, :string
    field :route, :string
    field :status_code, :integer
    field :timestamp, :utc_datetime
    field :uuid, Ecto.UUID

    timestamps()
  end

  @doc false
  def changeset(log, attrs) do
    attrs = parse_timestamp(attrs)

    log
    |> cast(attrs, [:uuid, :message, :status_code, :http_method, :duration, :route, :timestamp])
    |> validate_required([:uuid, :message])
  end

  @doc """
  Given a uuid and a str, parse it and insert if valid
  We try to extract as much data as we can from the `str`
  """
  def parse(uuid, str) do
    str = remove_trailing_new_lines(str)

    %__MODULE__{uuid: uuid, message: str}
    |> __MODULE__.changeset(Regex.named_captures(@started_regex, str) || %{})
    |> __MODULE__.changeset(Regex.named_captures(@completed_regex, str) || %{})
    |> Repo.insert()
  end

  @doc """
  Get the 5 most popular routes in the logs based on occurrence
  """
  def popular_routes do
    query = from logs in __MODULE__, select: {logs.route, count()},
                                     where: not is_nil(logs.route),
                                     group_by: logs.route,
                                     order_by: [desc: logs.count],
                                     limit: 5
    Repo.all(query)
  end

  @doc """
  Get the most popular HTTP Methods in the logs based on occurrence
  """
  def popular_methods do
    query = from logs in __MODULE__, select: {logs.http_method, count()},
                                     where: not is_nil(logs.http_method),
                                     group_by: logs.http_method,
                                     order_by: [desc: logs.count]
    Repo.all(query)
  end

  @doc """
  Get the 5 slowest routes in the logs based on occurrence
  """
  def slowest_routes do
    query = from logs in __MODULE__, join: logs2 in __MODULE__,
                                     on: logs.uuid == logs2.uuid and not is_nil(logs2.route),
                                     select: {logs.uuid, logs2.route, max(logs.duration)},
                                     where: not is_nil(logs.duration),
                                     group_by: [logs.uuid, logs.duration, logs2.route],
                                     order_by: [desc: logs.duration],
                                     limit: 5
    Repo.all(query)
  end

  @doc """
  Get the most recent 100 logs
  """
  def get_logs() do
    Repo.all(from logs in __MODULE__, limit: 100, order_by: [desc: logs.id])
  end

  @doc """
  Search for a specific uuid
  """
  def get_logs(<< uuid :: binary-size(36) >>) do
    Repo.all(from logs in __MODULE__, where: logs.uuid == ^uuid,
                                      limit: 100)
  end

  @doc """
  Get the first 100 results for a given query
  """
  def get_logs(query) do
    ilike = "%#{query}%"

    Repo.all(from logs in __MODULE__, where: ilike(logs.message, ^ilike),
                                      limit: 100)
  end

  defp remove_trailing_new_lines(str), do: String.replace(str, ~r/\n+$/, "")

  defp parse_timestamp(attrs) do
    if attrs["timestamp"] do
      Map.put(attrs, "timestamp", Timex.parse!(attrs["timestamp"], "%F %T %z", :strftime))
    else
      attrs
    end
  end
end
