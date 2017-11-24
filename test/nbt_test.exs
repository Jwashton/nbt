defmodule NBTTest do
  use ExUnit.Case, async: true

  doctest NBT

  test "can parse the hello file" do
    input = File.read!("test/fixtures/hello_world.nbt")
    output = %{"hello world" => %{"name" => "Bananrama"}}

    assert NBT.parse(input) == output
  end

  test "can parse the big file" do
    input =
      "test/fixtures/bigtest.nbt"
      |> File.read!()
      |> :zlib.gunzip()

    assert %{
             "Level" => %{
               "byteArrayTest (the first 1000 values of (n*n*255+n*7)%100, starting with n=0 (0, 62, 34, 16, 8, ...))" =>
                 [0, 62, 34, 16, 8, 10, 22 | _rest],
               "byteTest" => 127,
               "doubleTest" => 0.4931287132182315,
               "floatTest" => 0.4982314705848694,
               "intTest" => 2_147_483_647,
               "listTest (compound)" => [
                 %{
                   "created-on" => 1_264_099_775_885,
                   "name" => "Compound tag #0"
                 },
                 %{
                   "created-on" => 1_264_099_775_885,
                   "name" => "Compound tag #1"
                 }
               ],
               "listTest (long)" => [11, 12, 13, 14, 15],
               "longTest" => 9_223_372_036_854_775_807,
               "nested compound test" => %{
                 "egg" => %{"name" => "Eggbert", "value" => 0.5},
                 "ham" => %{"name" => "Hampus", "value" => 0.75}
               },
               "shortTest" => 32767,
               "stringTest" => "HELLO WORLD THIS IS A TEST STRING ÅÄÖ!"
             }
           } = NBT.parse(input)
  end
end
