defmodule Streamer do
  use Component.Strategy.Dynamic, top_level: true

  one_way whatever(top_level) do
    me = self()

    top_level
    |> Hasher.consume(timeout: 6_000_000)
  end
end
