defmodule TetrisWeb.GameLive.Welcome do
  use TetrisWeb, :live_view

  def mount(_params, _session, socket), do: {:ok, socket}

  def handle_event("play", _, socket), do: {:noreply, play(socket)}

  defp play(socket), do: push_redirect(socket, to: "/game/playing")
end
