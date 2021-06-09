defmodule Tetris.Game do
  defstruct [:tetro, points: [], score: 0, junkyard: %{}]

  alias Tetris.{Tetromino, Points}

  def new_tetromino(game), do: %{ game | tetro: Tetromino.new_random() } |> show

  def show(game), do: %{ game | points: Tetromino.show(game.tetro) }

  def left(game),   do: game |> move(&Tetromino.left/1)   |> show
  def right(game),  do: game |> move(&Tetromino.right/1)  |> show
  def rotate(game), do: game |> move(&Tetromino.rotate/1) |> show

  def move(game, move_fn) do
    old = game.tetro
    new =
      game.tetro
      |> move_fn.()
    valid =
      new
      |> Tetromino.show()
      |> Points.all_valid?()
    Tetromino.maybe_move(old, new, valid)
  end
end
