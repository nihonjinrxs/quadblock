defmodule Tetris.Points do
  alias Tetris.Point

  def move(points, change) do
    points
    |> Enum.map(&Point.move(&1, change))
  end

  def rotate(points, degrees) do
    points
    |> Enum.map(&Point.rotate(&1, degrees))
  end

  def add_shape(points, shape) do
    points
    |> Enum.map(&Point.add_shape(&1, shape))
  end

  def all_valid?(points) do
    points
    |> Enum.all?(&Point.in_bounds?/1)
  end
end
