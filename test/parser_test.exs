defmodule NBT.ParserTest do
  use ExUnit.Case, async: true

  alias NBT.Parser

  doctest Parser

  test "take_next will identify a TAG_End" do
    input = <<0>>

    assert Parser.take_next(input) == {:end, ""}
  end

  test "take_next will identify a TAG_Byte" do
    input = <<1, 7::integer-size(16), "meaning", 42>>
    output = {{:byte, "meaning", 42}, ""}

    assert Parser.take_next(input) == output
  end

  test "take_next will identify a TAG_Short" do
    input = <<2, 8::integer-size(16), "birthday", 0x07C8::integer-size(16)>>
    output = {{:short, "birthday", 1992}, ""}

    assert Parser.take_next(input) == output
  end

  test "take_next will identify a TAG_Int" do
    input = <<3, 8::integer-size(16), "all ones", 0xFFFFFFFF::integer-size(32)>>
    output = {{:int, "all ones", 0xFFFFFFFF}, ""}

    assert Parser.take_next(input) == output
  end

  test "take_next will identify a TAG_Long" do
    input = <<4, 10::integer-size(16), "secret msg", 0xFEEDCAFEDEADBEEF::8*8>>
    output = {{:long, "secret msg", 0xFEEDCAFEDEADBEEF}, ""}

    assert Parser.take_next(input) == output
  end

  test "take_next will identify a TAG_Float" do
    input = <<5, 10::integer-size(16), "small half", 63, 192, 0, 0>>
    output = {{:float, "small half", 1.5}, ""}

    assert Parser.take_next(input) == output
  end

  test "take_next will identify a TAG_Double" do
    input = <<6, 8::integer-size(16), "big half", 63, 248, 0, 0, 0, 0, 0, 0>>
    output = {{:double, "big half", 1.5}, ""}

    assert Parser.take_next(input) == output
  end

  test "take_next will identify a TAG_Byte_Array" do
    input = <<
      7,
      6::integer-size(16),
      "primes",
      9::integer-size(32),
      2,
      3,
      5,
      7,
      11,
      13,
      17,
      19,
      23
    >>

    output = {{:byte_array, "primes", [2, 3, 5, 7, 11, 13, 17, 19, 23]}, ""}

    assert Parser.take_next(input) == output
  end

  test "take_next will identify a TAG_String" do
    input = <<
      8,
      7::integer-size(16),
      "my name",
      7::integer-size(16),
      "William"
    >>

    output = {{:string, "my name", "William"}, ""}

    assert Parser.take_next(input) == output
  end

  test "take_next will identify a TAG_List" do
    input = <<
      9,
      6::integer-size(16),
      "colors",
      8,
      3::integer-size(32),
      3::integer-size(16),
      "red",
      5::integer-size(16),
      "green",
      4::integer-size(16),
      "blue"
    >>

    output = {{:list, "colors", ["red", "green", "blue"]}, ""}

    assert Parser.take_next(input) == output
  end

  test "take_next will identify a TAG_Compound" do
    input = <<
      10,
      5::integer-size(16),
      "stats",
      1,
      5::integer-size(16),
      "hours",
      17,
      8,
      4::integer-size(16),
      "task",
      7::integer-size(16),
      "reading",
      0
    >>

    output = {{:compound, "stats", %{"hours" => 17, "task" => "reading"}}, ""}

    assert Parser.take_next(input) == output
  end

  test "take_next will identify a TAG_Int_Array" do
    input = <<
      11,
      9::integer-size(16),
      "Fibonacci",
      7::integer-size(32),
      0::integer-size(32),
      1::integer-size(32),
      1::integer-size(32),
      2::integer-size(32),
      3::integer-size(32),
      5::integer-size(32),
      8::integer-size(32)
    >>

    output = {{:int_array, "Fibonacci", [0, 1, 1, 2, 3, 5, 8]}, ""}

    assert Parser.take_next(input) == output
  end

  test "take_next will identify a TAG_Long_Array" do
    input = <<
      12,
      13::integer-size(16),
      "phone numbers",
      3::integer-size(32),
      1112223333::integer-size(64),
      1234567890::integer-size(64),
      3125550690::integer-size(64)
    >>

    output = {{:long_array, "phone numbers", [1112223333, 1234567890, 3125550690]}, ""}

    assert Parser.take_next(input) == output
  end
end
