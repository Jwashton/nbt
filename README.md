# NBT

[![Hex pm](http://img.shields.io/hexpm/v/nbt.svg?style=flat)](https://hex.pm/packages/nbt)

Functions for parsing Named Binary Tag files, common to Minecraft save files.

## Installation

NBT is available on [hex.pm](https://hex.pm/packages/nbt). The package can be installed
by adding `nbt` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:nbt, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and found online at [https://hexdocs.pm/nbt](https://hexdocs.pm/nbt).

## Usage

This library does not currently handle file management or compression. I
recommend some research into the build-in `:zlib` Erlang module for the various
compression tools you will need for parsing minecraft files.

```
"test/fixtures/bigtest.nbt"
|> File.read!()
|> :zlib.gunzip()
|> NBT.parse
```

## Resources

For the curious, here is a list of pages that I found useful in writing this
library.

* [The Original Spec from Notch](http://web.archive.org/web/20110723210920/http://www.minecraft.net/docs/NBT.txt)
* [A wiki page with the original test files](http://wiki.vg/NBT)
* [The NBT page from the official Minecraft wiki](https://minecraft.gamepedia.com/NBT_format)

