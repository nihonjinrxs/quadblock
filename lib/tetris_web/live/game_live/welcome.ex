defmodule TetrisWeb.GameLive.Welcome do
  use TetrisWeb, :live_view

  def mount(_params, _session, socket), do: {:ok, socket |> assign(play_fn: &play/1)}

  def play(socket), do: socket |> push_redirect(to: "/game/playing")
end
