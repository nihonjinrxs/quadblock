defmodule TetrisWeb.GameLive.Playing do
  use TetrisWeb, :live_view

  alias Tetris.Game

  @rotate_keys ["ArrowUp", " "]

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      :timer.send_interval(350, :tick)
    end
    {:ok, new_game(socket)}
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
    <%= for {x, y, shape} <- @game.points ++ Game.junkyard_points(@game) do %>
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

  def maybe_end_game(%{assigns: %{game: %{game_over: true, score: score}}}=socket) do
    socket
    |> push_redirect(to: "/game/over?score=#{score}")
  end
  def maybe_end_game(socket), do: socket

  @impl true
  def handle_info(:tick, socket) do
    {:noreply, socket |> down |> maybe_end_game}
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
