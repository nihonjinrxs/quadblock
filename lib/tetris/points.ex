defmodule Tetris.Points do
  alias Tetris.Point

  def move(points, change) do
    points
    |> Enum.map(&Point.move(&1, change))
  end
end
