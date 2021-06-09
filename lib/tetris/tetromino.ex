defmodule Tetris.Tetromino do
  @shapes ~w[i o j l z s t]a
  @rotations [0, 90, 180, 270]

  alias Tetris.{Point, Points}

  defstruct shape: :l, rotation: 0, location: {3, 0}

  def new(options \\ []), do: __struct__(options)
  def new_random, do: new(shape: random_shape(), rotation: random_rotation())

  def left(%{location: loc}=tetro), do: %{tetro | location: Point.left(loc)}
  def right(%{location: loc}=tetro), do: %{tetro | location: Point.right(loc)}
  def down(%{location: loc}=tetro), do: %{tetro | location: Point.down(loc)}
  def rotate(%{rotation: rot}=tetro), do: %{tetro | rotation: rotate_90(rot)}

  def show(tetro) do
    tetro
    |> points
    |> Points.rotate(tetro.rotation)
    |> Points.move(tetro.location)
    |> Points.add_shape(tetro.shape)
  end

  defp points(%{shape: :i}=_tetro) do
    [
      {2, 1},
      {2, 2},
      {2, 3},
      {2, 4},
    ]
  end
  defp points(%{shape: :o}=_tetro) do
    [
      {2, 2}, {3, 2},
      {2, 3}, {3, 3},
    ]
  end
  defp points(%{shape: :j}=_tetro) do
    [
              {3, 1},
              {3, 2},
      {2, 3}, {3, 3},
    ]
  end
  defp points(%{shape: :l}=_tetro) do
    [
      {2, 1},
      {2, 2},
      {2, 3}, {3, 3},
    ]
  end
  defp points(%{shape: :z}=_tetro) do
    [
      {1, 2}, {2, 2},
              {2, 3}, {3, 3},
    ]
  end
  defp points(%{shape: :s}=_tetro) do
    [
              {2, 2}, {3, 2},
      {1, 3}, {2, 3},
    ]
  end
  defp points(%{shape: :t}=_tetro) do
    [
      {1, 2}, {2, 2}, {3, 2},
              {2, 3},
    ]
  end

  defp random_shape, do: @shapes |> Enum.random
  defp random_rotation, do: @rotations |> Enum.random
  defp rotate_90(270), do: 0
  defp rotate_90(n), do: n + 90

  def maybe_move(_old_tetro, new_tetro, true=_valid), do: new_tetro
  def maybe_move(old_tetro, _new_tetro, false=_valid), do: old_tetro
end
