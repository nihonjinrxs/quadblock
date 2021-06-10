defmodule Tetris.Game do
  defstruct [:tetro, points: [], score: 0, junkyard: %{}]

  alias Tetris.{Tetromino, Points}

  def new(), do: __struct__() |> new_tetromino |> show
  def new_tetromino(game), do: %{ game | tetro: Tetromino.new_random() } |> show

  def show(%{tetro: tetro}=game), do: %{ game | points: Tetromino.show(tetro) }

  def left(game),   do: game |> move(&Tetromino.left/1)   |> show
  @spec right(%{:__struct__ => any, optional(any) => any}) :: %{
          :points => list,
          :tetro => %{
            :location => any,
            :rotation => any,
            :shape => :i | :j | :l | :o | :s | :t | :z,
            optional(any) => any
          },
          optional(any) => any
        }
  def right(game),  do: game |> move(&Tetromino.right/1)  |> show
  def down(game),   do: game |> move(&Tetromino.down/1)   |> show
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
    %{ game | tetro: Tetromino.maybe_move(old, new, valid) }
  end
end
