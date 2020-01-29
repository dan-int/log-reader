defmodule LogReader.Log do
  use Ecto.Schema
  import Ecto.Changeset

  alias LogReader.Repo

  # Started GET "/" for 127.0.0.1 at 2016-03-30 15:58:41 -0400
  @started_regex ~r/Started\s(?<http_method>(GET)|(POST)|(PUT)|(PATCH)|(DELETE))\s\"(?<route>\S+)\".+at\s(?<timestamp>.+)/

  # Completed 200 OK in 388ms
  @completed_regex ~r/Completed\s(?<status_code>[0-9]+)\s.+\sin\s(?<duration>[0-9]+)+ms/

  schema "logs" do
    field :duration, :float
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

  def parse(uuid, str) do
    str = remove_trailing_new_lines(str)

    %__MODULE__{uuid: uuid, message: str}
    |> __MODULE__.changeset(Regex.named_captures(@started_regex, str) || %{})
    |> __MODULE__.changeset(Regex.named_captures(@completed_regex, str) || %{})
    |> Repo.insert()
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
