defmodule LogReader.BrowseLive do
  use Phoenix.LiveView
  alias LogReader.Log

  def render(assigns) do
    ~L"""
    <h2 class="header">Browse Logs</h2>
    <form phx-change="search" phx-submit="search" onsubmit="return false">
      <input type="text" name="query" value="<%= @query %>" phx-debounce="500" placeholder="Search" />
    </form>

    <div>
      <%= for log <- @logs do %>
        <pre class="log-row"><%= log.uuid %> <%= log.message %></pre>
      <% end %>

      <%= if length(@logs) == 0 do %>
        <h4>No data found</h5>
      <% end %>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket
      |> assign(:query, "")
      |> assign(:logs, Log.get_logs())
    }
  end

  def handle_event("search", %{"query" => query}, socket) do
    {:noreply, socket
      |> assign(:query, query)
      |> assign(:logs, Log.get_logs(query))
    }
  end
end
