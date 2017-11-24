defmodule NBT.Util do
  @moduledoc """
  Utility functions for NBT parsing
  """

  @doc """
  Unfold a value into a list.

  Returns a tuple containing the list and the remaining tail after an early
  return. A wrapup function is accepted to clean up the accumulator to
  make early returns easier. Ends the partial_unfold if step returns nil.
  """
  @spec partial_unfold(any, (any -> nil | {any, any}), (any -> any)) ::
          {list, any}
  def partial_unfold(data, step, finish) do
    partial_unfold(data, [], step, finish)
  end

  defp partial_unfold(data, result, step, finish) do
    case step.(data) do
      nil -> {Enum.reverse(result), finish.(data)}
      {val, acc} -> partial_unfold(acc, [val | result], step, finish)
    end
  end
end
