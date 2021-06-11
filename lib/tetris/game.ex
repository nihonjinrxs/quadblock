defmodule Tetris.Game do
  defstruct [:tetro, points: [], score: 0, junkyard: %{}, game_over: false]

  alias Tetris.{Tetromino, Points}

  def new(), do: __struct__() |> new_tetromino |> show
  def new_tetromino(game), do: %{ game | tetro: Tetromino.new_random() } |> show

  def show(%{tetro: tetro}=game), do: %{ game | points: Tetromino.show(tetro) }

  def left(game),   do: game |> move(&Tetromino.left/1)   |> show
  def right(game),  do: game |> move(&Tetromino.right/1)  |> show
  def rotate(game), do: game |> move(&Tetromino.rotate/1) |> show

  def down(game) do
    {old, new, valid} = move_data(game, &Tetromino.down/1)

    move_down_or_merge(game, old, new, valid)
  end

  def move_down_or_merge(game, _old, new, true=_valid)  do
    %{ game | tetro: new }
    |> show
    |> increment_score(1)
  end
  def move_down_or_merge(game, old, _new, false=_valid) do
    game
    |> merge(old)
    |> new_tetromino
    |> show
    |> check_game_over
  end

  def merge(game, tetro) do
    new_junkyard =
      tetro
      |> Tetromino.show()
      |> Enum.map(fn {x, y, shape} -> {{x, y}, shape} end)
      |> Enum.into(game.junkyard)

    %{ game | junkyard: new_junkyard }
    |> collapse_rows
  end

  def collapse_rows(game) do
    rows = complete_rows(game)

    game
    |> absorb(rows)
    |> score_rows(rows)
  end

  def absorb(game, []), do: game
  def absorb(game, [ y | ys ]), do: remove_row(game, y) |> absorb(ys)

  def remove_row(game, row) do
    new_junkyard =
      game.junkyard
      |> Enum.reject(fn {{_x, y}, _shape} -> y == row end)
      |> Enum.map(fn {{x, y}, shape} ->
        {{x, maybe_move_y_down(y, row)}, shape}
      end)
      |> Map.new

    %{ game | junkyard: new_junkyard }
  end

  def maybe_move_y_down(y, row) when y < row, do: y + 1
  def maybe_move_y_down(y, _row), do: y

  def score_rows(game, rows) do
    new_score =
      :math.pow(2, length(rows))
      |> round()
      |> Kernel.*(100)
      |> Kernel.+(game.score)

    %{ game | score: new_score }
  end

  defp complete_rows(game) do
    game.junkyard
    |> Map.keys
    |> Enum.group_by(fn {_x, y} -> y end)
    |> Enum.filter(fn {_y, list} -> length(list) == 10 end)
    |> Enum.map(fn {y, _list} -> y end)
  end

  def junkyard_points(game) do
    game.junkyard
    |> Enum.map(fn {{x, y}, shape} -> {x, y, shape} end)
  end

  def move(game, move_fn) do
    {old, new, valid} = move_data(game, move_fn)
    moved = Tetromino.maybe_move(old, new, valid)

    %{ game | tetro: moved }
    |> show
  end

  defp move_data(game, move_fn) do
    old = game.tetro
    new =
      game.tetro
      |> move_fn.()
    valid =
      new
      |> Tetromino.show()
      |> Points.valid?(game.junkyard)

    {old, new, valid}
  end

  def increment_score(game, value), do: %{ game | score: game.score + value }

  def check_game_over(game) do
    continue_game =
      game.tetro
      |> Tetromino.show
      |> Points.valid?(game.junkyard)

    %{ game | game_over: !continue_game }
  end
end
