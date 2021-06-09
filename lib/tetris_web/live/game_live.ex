defmodule TetrisWeb.GameLive do
  use TetrisWeb, :live_view

  alias Tetris.Tetromino

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      :timer.send_interval(500, :tick)
    end
    {
      :ok,
      socket
      |> new_tetromino
      |> show
    }
  end

  @impl true
  def render(assigns) do
    ~L"""
    <section class="phx-hero">
      <h1>Quadblock Tetris</h1>
      <%= render_board(assigns) %>
      <pre>
        @tetro = <%= inspect @tetro %>
        @points = <%= inspect @points %>
      </pre>
    </section>
    """
  end

  defp new_tetromino(socket) do
    assign(socket, tetro: Tetromino.new_random())
  end

  defp show(socket) do
    assign(socket,
      points:
        socket.assigns.tetro
        |> Tetromino.show()
    )
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
    <%= for {x, y, shape} <- @points do %>
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
    {:noreply, socket |> down |> rotate |> show}
  end

  defp rotate(%{assigns: %{tetro: tetro}}=socket) do
    assign(socket, tetro: Tetromino.rotate(tetro))
  end

  defp down(%{assigns: %{tetro: %{location: {_, 20}}}}=socket) do
    socket
    |> new_tetromino
  end
  defp down(%{assigns: %{tetro: tetro}}=socket) do
    assign(socket, tetro: Tetromino.down(tetro))
  end
end
