defmodule NBT.Parser do
  @moduledoc """
  Parsing functions that turn an NBT binary into native elixir types.
  """

  import NBT.Util, only: [partial_unfold: 3]

  @type next :: nil | {:end, binary} | {{atom, binary, binary}, binary}

  @doc """
  Given a partial NBT binary, returns the next TAG and the rest of the binary.

  ## Example

      iex> Parser.take_next(<< 1, 5::2*8, "votes", 26, "more data" >>)
      {{:byte, "votes", 26}, "more data"}

  """
  @spec take_next(binary) :: nil | {next, binary}
  def take_next(""), do: nil
  def take_next(<<0, rest::binary>>), do: {:end, rest}

  def take_next(<<type::integer-size(8), name_data_and_rest::binary>>) do
    {name, data_and_rest} = take_name(name_data_and_rest)

    {data, rest} = take_value(type, data_and_rest)

    {{typename(type), name, data}, rest}
  end

  defp take_name(<<name_length::integer-size(16), name_and_rest::binary>>) do
    name = binary_part(name_and_rest, 0, name_length)
    rest = String.replace_prefix(name_and_rest, name, "")

    {name, rest}
  end

  defp take_value(1, <<data::integer-size(8), rest::binary>>), do: {data, rest}
  defp take_value(2, <<data::integer-size(16), rest::binary>>), do: {data, rest}
  defp take_value(3, <<data::integer-size(32), rest::binary>>), do: {data, rest}
  defp take_value(4, <<data::integer-size(64), rest::binary>>), do: {data, rest}
  defp take_value(5, <<data::float-size(32), rest::binary>>), do: {data, rest}
  defp take_value(6, <<data::float-size(64), rest::binary>>), do: {data, rest}

  defp take_value(7, <<array_length::integer-size(32), data_and_rest::binary>>) do
    data = binary_part(data_and_rest, 0, array_length)

    rest = String.replace_prefix(data_and_rest, data, "")

    {:binary.bin_to_list(data), rest}
  end

  defp take_value(8, data_and_rest), do: take_name(data_and_rest)

  defp take_value(9, <<
         type::integer-size(8),
         list_length::integer-size(32),
         data_and_rest::binary
       >>) do
    partial_unfold(
      {0, data_and_rest},
      fn
        {^list_length, _stream} ->
          nil

        {n, stream} ->
          {value, rest} = take_value(type, stream)

          {value, {n + 1, rest}}
      end,
      &elem(&1, 1)
    )
  end

  defp take_value(10, data) do
    {children, rest} =
      partial_unfold(
        {false, data},
        fn
          {true, _vals} ->
            nil

          {false, vals} ->
            case take_next(vals) do
              {:end, rest} -> {:end, {true, rest}}
              {value, rest} -> {value, {false, rest}}
            end
        end,
        &elem(&1, 1)
      )

    data =
      children
      |> Enum.reduce(%{}, fn
           :end, compound -> compound
           {_type, key, val}, compound -> Map.put(compound, key, val)
         end)

    {data, rest}
  end

  defp take_value(11, <<array_length::integer-size(32), data_and_rest::binary>>) do
    data = binary_part(data_and_rest, 0, array_length * 4)

    rest = String.replace_prefix(data_and_rest, data, "")

    step = fn
      "" ->
        nil

      acc ->
        <<next::integer-size(32), rest::binary>> = acc

        {next, rest}
    end

    list =
      data
      |> Stream.unfold(step)
      |> Enum.to_list()

    {list, rest}
  end

  @spec typename(1..11) :: atom()
  defp typename(1), do: :byte
  defp typename(2), do: :short
  defp typename(3), do: :int
  defp typename(4), do: :long
  defp typename(5), do: :float
  defp typename(6), do: :double
  defp typename(7), do: :byte_array
  defp typename(8), do: :string
  defp typename(9), do: :list
  defp typename(10), do: :compound
  defp typename(11), do: :int_array
end
