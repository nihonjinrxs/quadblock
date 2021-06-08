defmodule Tetris.Tetromino do
  @shapes ~w[i o j l z s t]a
  @rotations [0, 90, 180, 270]

  alias Tetris.Point

  defstruct shape: :l, rotation: 0, location: {5, 1}

  def new(options \\ []), do: __struct__(options)
  def new_random, do: new(shape: random_shape(), rotation: random_rotation())

  def left(%{location: loc}=tetro), do: %{tetro | location: Point.left(loc)}
  def right(%{location: loc}=tetro), do: %{tetro | location: Point.right(loc)}
  def down(%{location: loc}=tetro), do: %{tetro | location: Point.down(loc)}
  def rotate(%{rotation: rot}=tetro), do: %{tetro | rotation: rotate_degrees(rot)}

  defp random_shape, do: @shapes |> Enum.random
  defp random_rotation, do: @rotations |> Enum.random
  defp rotate_degrees(270), do: 0
  defp rotate_degrees(n), do: n + 90
end
