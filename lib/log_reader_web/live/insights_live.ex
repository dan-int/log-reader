defmodule LogReader.InsightsLive do
  use Phoenix.LiveView
  alias LogReader.Log

  def render(assigns) do
    ~L"""
    <div class="insight-box">
      <h2 class="header">Most popular routes</h2>
      <div class="insight">
        <div class="insight-count"><h5>Hits</h5></div>
        <div class="insight-value"><h5>Route</h5></div>
        <%= for {route, count} <- @popular_routes do %>
          <div class="insight-count"><%= count %></div>
          <div class="insight-value"><%= route %></div>
        <% end %>
      </div>
    </div>

    <div class="insight-box">
      <h2 class="header">Most popular HTTP methods</h2>
      <div class="insight">
        <div class="insight-count"><h5>Hits</h5></div>
        <div class="insight-value"><h5>HTTP Method</h5></div>
        <%= for {method, count} <- @popular_methods do %>
          <div class="insight-count"><%= count %></div>
          <div class="insight-value"><%= method %></div>
        <% end %>
      </div>
    </div>

    <div class="insight-box">
      <h2 class="header">Slowest Routes (max)</h2>
      <div class="insight">
        <div class="insight-count"><h5>Duration</h5></div>
        <div class="insight-value"><h5>Route</h5></div>
        <%= for {_uuid, route, duration} <- @slowest_routes do %>
          <div class="insight-count"><%= duration %> ms</div>
          <div class="insight-value"><%= route %></div>
        <% end %>
      </div>
    </div>
    """
  end

  def mount(params, session, socket) do
    {:ok, socket
      |> assign(:popular_routes, Log.popular_routes())
      |> assign(:popular_methods, Log.popular_methods())
      |> assign(:slowest_routes, Log.slowest_routes())
    }
  end
end
