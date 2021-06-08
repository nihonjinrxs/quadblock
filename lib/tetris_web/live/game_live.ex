defmodule TetrisWeb.GameLive do
  use TetrisWeb, :live_view

  alias Tetris.Tetromino

  @impl true
  def mount(_params, _session, socket) do
    :timer.send_interval(500, :tick)
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
    <% [{x, y}] = @points %>
    <section class="phx-hero">
      <h1>Quadblock Tetris</h1>
      <%= render_board(assigns) %>
      <pre>
        Shape <%= inspect @tetro.shape %>
        <%= @tetro.rotation %> degrees
        {<%= x %>, <%= y %>}
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
        |> Tetromino.points()
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

  defp render_points(%{points: [{x, y}]}=assigns) do
    ~L"""
    <rect
      width="20" height="20"
      x="<%= (x - 1) * 20 %>" y="<%= (y - 1) * 20 %>"
      style="fill:rgb(255,0,0)"
    />
    """
  end

  @impl true
  def handle_info(:tick, socket) do
    {:noreply, socket |> down |> show}
  end

  defp down(%{assigns: %{tetro: %{location: {_, 20}}}}=socket) do
    socket
    |> new_tetromino
  end
  defp down(%{assigns: %{tetro: tetro}}=socket) do
    assign(socket, tetro: Tetromino.down(tetro))
  end
end
