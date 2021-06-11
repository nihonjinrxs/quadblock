defmodule TetrisWeb.GameLive.GameOver do
  use TetrisWeb, :live_view

  def mount(params, _session, socket) do
    {
      :ok,
      socket
      |> assign(score: params["score"])
      |> assign(play_fn: &play/1)
    }
  end

  def play(socket), do: socket |> push_redirect(to: "/game/playing")
end
