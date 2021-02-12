defmodule Practice do
  @moduledoc """
  Practice keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def double(x) do
    2 * x
  end

  def calc(expr) do
    # This is more complex, delegate to lib/practice/calc.ex
    Practice.Calc.calc(expr)
  end

  def factor(x, t \\ 2, factors \\ []) do
    cond do
      x < 2 ->
        factors
      rem(x, t) == 0 ->
        factor(div(x, t), 2, factors ++ [t])
      true ->
        factor(x, t + 1, factors)
    end
  end

  def palindrome?(s) do
    len = String.length(s)
    cond do
      len < 2 -> true
      true ->
        String.at(s, 0) === String.at(s, len - 1) &&
          palindrome?(String.slice(s, 1, len - 2))
    end
  end
end
