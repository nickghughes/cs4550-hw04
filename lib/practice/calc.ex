defmodule Practice.Calc do
  def parse_float(text) do
    {num, _} = Float.parse(text)
    num
  end

  def is_op?(token) do
    Enum.any?(["+", "-", "*", "/"], fn(x) -> x === token end)
  end

  def priority(op) do
    case op do
      "+" -> 0
      "-" -> 0
      "*" -> 1
      "/" -> 1
    end
  end

  def tag_token(token) do
    cond do
      is_op?(token) -> {:op, token}
      true -> {:num, parse_float(token)}
    end
  end

  def tag_tokens([]), do: []

  def tag_tokens(tokens) do
    [tag_token(hd(tokens)) | tag_tokens(tl(tokens))]
  end

  def to_postfix(_, out \\ [], stack \\ [])

  def to_postfix([], out, stack) do
    out ++ stack
  end

  def to_postfix([{:op, op} | tokens], out, stack) do
    cond do
      stack === [] ->
        to_postfix(tokens, out, [op])
      priority(op) > priority(hd(stack)) ->
        to_postfix(tokens, out, [op | stack])
      priority(op) === priority(hd(stack)) ->
        to_postfix(tokens, out ++ [hd(stack)], [op | tl(stack)])
      priority(op) < priority(hd(stack)) ->
        to_postfix([{:op, op} | tokens], out ++ [hd(stack)], tl(stack))
    end
  end

  def to_postfix([{:num, num} | tokens], out, stack) do
    to_postfix(tokens, out ++ [num], stack)
  end

  def to_prefix(_, stack \\ [])

  def to_prefix([], stack) do
    hd stack
  end

  def to_prefix([token | postfix], stack) do
    cond do
      is_op?(token) ->
        to_prefix(postfix, tl(tl(stack)) ++ [[token, hd(stack), hd(tl(stack))]])
      true ->
        to_prefix(postfix, [token | stack])
    end
  end

  def eval(["+" | operands]) do
    eval(hd(tl(operands))) + eval(hd(operands))
  end

  def eval(["-" | operands]) do
    eval(hd(tl(operands))) - eval(hd(operands))
  end

  def eval(["*" | operands]) do
    eval(hd(tl(operands))) * eval(hd(operands))
  end

  def eval(["/" | operands]) do
    eval(hd(tl(operands))) / eval(hd(operands))
  end

  def eval(num) do
    num
  end

  def calc(expr) do
    # This should handle +,-,*,/ with order of operations,
    # but doesn't need to handle parens.
    expr
    |> String.split(~r/\s+/)
    |> tag_tokens
    |> to_postfix
    |> to_prefix
    |> eval
  end

  def factor(x, t, factors) do
    cond do
      x < 2 ->
        factors
      rem(x, t) == 0 ->
        factor(div(x, t), 2, factors ++ [t])
      true ->
        factor(x, t + 1, factors)
    end
  end
end
