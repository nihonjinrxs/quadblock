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

  defp play(socket), do: push_redirect(socket, to: "/game/playing")
end
