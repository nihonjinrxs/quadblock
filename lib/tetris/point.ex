defmodule Tetris.Point do
  def origin(), do: {0, 0}

  def left({x, y}), do: {x-1, y}
  def right({x, y}), do: {x+1, y}
  def down({x, y}), do: {x, y+1}
  def move({x, y}, {dx, dy}), do: {x + dx, y + dy}

  def transpose({x, y}), do: {y, x}
  def mirror({x, y}), do: {5 - x, y}
  def flip({x, y}), do: {x, 5 - y}

  def rotate(point, 0), do: point
  def rotate(point, 90), do: point |> flip() |> transpose()
  def rotate(point, 180), do: point |> mirror() |> flip()
  def rotate(point, 270), do: point |> mirror() |> transpose()

  def add_shape({x, y}, shape), do: {x, y, shape}
  def add_shape(point_with_shape, _shape), do: point_with_shape
end
