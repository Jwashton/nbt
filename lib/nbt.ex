defmodule NBT do
  @moduledoc """
  Parsing functions to convert NBT (Named Binary Tag) data into native Elixir
  values. This library does not currently handle file management or
  compression, both of those steps are left to the user.
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
