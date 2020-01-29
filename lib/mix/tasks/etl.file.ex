defmodule Mix.Tasks.Etl.File do
  @moduledoc """
  This module takes a file and processes it

  eg. `mix etl.file /path/to/log-file`
  """

  use Mix.Task

  @shortdoc "Processes a log file"

  def run([file_path | _tail]) do
    Mix.Task.run("app.start")

    if file_path do
      Mix.shell().info("Processing #{file_path}...")

      # Process the file via a stream for memory efficiency
      buffer = File.stream!(file_path)
      |> Enum.reduce({"", ""}, fn line, buffer ->
        # we keep a buffer in case of multi-line logs
        parse_line(line, buffer)
      end)

      # process the last item in the buffer
      parse_buffer(buffer)
    else
      Mix.shell().info("Please provide the path to the file to be processed")
    end
  end

  # parses a line with a uuid prefixed
  # processes the previous buffer
  # then start a new buffer
  defp parse_line("[" <> << uuid :: binary-size(36) >> <> "] " <> line, buffer) do
    parse_buffer(buffer)
    {uuid, line}
  end

  # this processes a line that does not have a uuid attached to it
  # simply, add the line to the buffer
  defp parse_line(line, {buffer_uuid, buffer_line}) do
    {buffer_uuid, buffer_line <> line}
  end

  # do nothing if uuid is blank
  defp parse_buffer({"", _buffer_line}), do: nil

  # parse what's currently in the buffer
  defp parse_buffer({buffer_uuid, buffer_line}) do
    IO.puts buffer_uuid <> buffer_line
  end
end
