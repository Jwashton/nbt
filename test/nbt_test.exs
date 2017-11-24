defmodule NBTTest do
  use ExUnit.Case, async: true

  doctest NBT

  test "can parse hello file" do
    input = File.read!("test/fixtures/hello_world.nbt")
    output = %{"hello world" => %{"name" => "Bananrama"}}

    assert NBT.parse(input) == output
  end
end
