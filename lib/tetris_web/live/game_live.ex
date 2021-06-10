defmodule TetrisWeb.GameLive do
  use TetrisWeb, :live_view

  alias Tetris.Game

  @rotate_keys ["ArrowUp", " "]

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      :timer.send_interval(500, :tick)
    end
    {:ok, new_game(socket)}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <section class="phx-hero">
      <div phx-window-keydown="keystroke">
        <h1>Quadblock Tetris</h1>
        <%= render_board(assigns) %>
        <pre>
          @tetro = <%= inspect @game.tetro %>
          @points = <%= inspect @game.points %>
        </pre>
      </div>
    </section>
    """
  end

  defp render_board(assigns) do
    ~L"""
    <svg width="200" height="400">
      <rect width="200" height="400" style="fill:rgb(0,0,0)" />
      <%= render_points(assigns) %>
    </svg>
    """
  end

  defp render_points(assigns) do
    ~L"""
    <%= for {x, y, shape} <- @game.points do %>
      <rect
        width="20" height="20"
        x="<%= (x - 1) * 20 %>" y="<%= (y - 1) * 20 %>"
        style="fill:<%= color(shape) %>"
      />
    <% end %>
    """
  end

  defp color(:z), do: "red"
  defp color(:l), do: "red"
  defp color(:s), do: "dodgerblue"
  defp color(:j), do: "dodgerblue"
  defp color(:i), do: "white"
  defp color(:o), do: "white"
  defp color(:t), do: "white"
  defp color(_), do: "saddlebrown"

  @impl true
  def handle_info(:tick, socket) do
    {:noreply, socket |> down}
  end

  @impl true
  def handle_event("keystroke", %{"key" => key}, socket) when key in @rotate_keys do
    {:noreply, socket |> rotate}
  end
  def handle_event("keystroke", %{"key" => "ArrowLeft"}, socket) do
    {:noreply, socket |> left}
  end
  def handle_event("keystroke", %{"key" => "ArrowRight"}, socket) do
    {:noreply, socket |> right}
  end
  def handle_event("keystroke", %{"key" => "ArrowDown"}, socket) do
    {:noreply, socket |> down}
  end
  def handle_event("keystroke", _, socket) do
    {:noreply, socket}
  end

  defp new_game(socket) do
    assign(socket, game: Game.new())
  end

  defp rotate(%{assigns: %{game: game}}=socket) do
    assign(socket, game: Game.rotate(game))
  end

  defp down(%{assigns: %{game: game}}=socket) do
    assign(socket, game: Game.down(game))
  end
  defp left(%{assigns: %{game: game}}=socket) do
    assign(socket, game: Game.left(game))
  end
  defp right(%{assigns: %{game: game}}=socket) do
    assign(socket, game: Game.right(game))
  end
end
