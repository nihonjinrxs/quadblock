defmodule TetrisWeb.GameLive.Components.PlayButton do
  use TetrisWeb, :live_component

  def render(assigns) do
    ~L"""
    <button class="css-framework-class" phx-click="play" phx-target="<%= @myself %>">
      <%= @title %>
    </button>
    """
  end

  def handle_event("play", _, socket), do: {:noreply, play(socket)}

  defp play(%{ assigns: %{ play_fn: play_fn }}=socket), do: play_fn.(socket)
  defp play(socket), do: socket |> push_redirect(to: "/game/playing")
end
