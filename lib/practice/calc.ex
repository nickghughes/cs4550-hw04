defmodule Practice.Calc do
  def parse_float(text) do
    {num, _} = Float.parse(text)
    num
  end

  def is_op?(token) do
    Enum.any?(["+", "-", "*", "/"], fn(x) -> x === token end)
  end

  # Used for postfix stack logic
  def priority(op) do
    case op do
      "+" -> 0
      "-" -> 0
      "*" -> 1
      "/" -> 1
    end
  end

  # Tags expr tokens i.e. "+" -> {:op, "+"}
  # Use pattern matching to handle various cases

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

  # Converts set of tagged tokens to postfix notation using stack algorithm

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

  # Converts postfix notation to prefix notation.
  # Result will have a structure similar to the following:
  #   ["+", [5.0, ["*", 10.0, 3.0]]]
  # This structure makes it easy to evaluate the solution using recursion

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

  # Evaluate the expression from prefix notation using pattern matching

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

  # Calculates expression containing floats and operators including
  #   +,-,*,/ with order of operations.

  def calc(expr) do
    expr
    |> String.split(~r/\s+/)
    |> tag_tokens
    |> to_postfix
    |> to_prefix
    |> eval
  end
end
