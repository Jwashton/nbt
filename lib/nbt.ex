defmodule NBT do
  @moduledoc """
  Documentation for NBT.
  """

  alias NBT.Parser

  @doc """
  Parses a valid NBT binary into a map.

  ## Example

      iex> NBT.parse(<<8, 4::16, "name", 5::16, "David">>)
      %{"name" => "David"}

  """
  @spec parse(binary) :: map
  def parse(data) do
    data
    |> Stream.unfold(&Parser.take_next/1)
    |> Enum.reduce(%{}, fn
         :end, compound -> compound
         {_type, key, val}, compound -> Map.put(compound, key, val)
       end)
  end
end
