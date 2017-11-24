defmodule NBT.UtilTest do
  use ExUnit.Case, async: true

  alias NBT.Util

  doctest Util

  # Don't do this, just a test case, use some of the many UTF-safe functions
  #   in the String module instead
  test "can unfold a binary into a list" do
    input = "foobar"
    output = 'foobar'

    {result, ""} =
      Util.partial_unfold(
        input,
        fn
          "" -> nil
          <<c::8, rest::binary>> -> {c, rest}
        end,
        & &1
      )

    assert result == output
  end

  # Don't do this, just a test case, use some of the many UTF-safe functions
  #   in the String module instead
  test "can unfold a binary into a list quitting early" do
    input = "foobar"

    assert {'foo', "bar"} =
             Util.partial_unfold(
               input,
               fn
                 <<?b, _rest::binary>> -> nil
                 <<c::8, rest::binary>> -> {c, rest}
               end,
               & &1
             )
  end
end
