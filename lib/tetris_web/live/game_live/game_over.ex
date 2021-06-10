defmodule TetrisWeb.GameLive.GameOver do
  use TetrisWeb, :live_view

  alias Tetris.Game

  def mount(_params, _session, socket) do
    {:ok, assign(socket, game: Map.get(socket.assigns, :game) || Game.new)}
  end

  def handle_event("play", _, socket), do: {:noreply, play(socket)}

  defp play(socket), do: push_redirect(socket, to: "/game/playing")
end
