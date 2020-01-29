defmodule LogReader.Repo.Migrations.CreateLogs do
  use Ecto.Migration

  def change do
    create table(:logs) do
      add :uuid, :uuid
      add :message, :text
      add :status_code, :integer
      add :http_method, :string
      add :duration, :integer
      add :route, :string
      add :timestamp, :utc_datetime

      timestamps()
    end

    create index("logs", [:uuid], comment: "Index UUID")
    create index("logs", [:status_code], comment: "Index status_code")
    create index("logs", [:http_method], comment: "Index http_method")
    create index("logs", [:duration], comment: "Index duration")
    create index("logs", [:route], comment: "Index route")
    create index("logs", [:timestamp], comment: "Index timestamp")
  end
end
