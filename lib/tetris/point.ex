defmodule Tetris.Point do
  def origin(), do: {0, 0}
  def left({x, y}), do: {x-1, y}
  def right({x, y}), do: {x+1, y}
  def down({x, y}), do: {x, y+1}
  def move({x, y}, {dx, dy}), do: {x + dx, y + dy}
end
