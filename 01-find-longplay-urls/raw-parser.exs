#! /usr/bin/env elixir

defmodule Term do
  def store(anything, path) do
    bin = :erlang.term_to_binary(anything)
    File.write!(path, bin)
  end

  def fetch(path) do
    File.read!(path) |> :erlang.binary_to_term()
  end
end

defmodule FileParser do
  @snes_regex ~r/(?<vid>\S+) SNES Longplay(?| \[\d+\])? (?<title>.*?)(\(Part (?<part_current>\d+) of (?<part_max>\d+)\))?$/i

  def read_file(filename) do
    file_name = Path.expand("./", __DIR__) |> Path.join(filename)
    {:ok, contents} = File.read(file_name)

    contents
    |> String.trim()
    |> String.split("\n", trim: true)
  end

  def parse_file(filename) do
    read_file(filename)
    |> filter_snes()
    |> parse_lines()
    |> group_title()
    |> to_list()
  end

  def filter_snes(lines), do: lines |> Enum.filter(&line_snes?/1)
  def parse_lines(lines), do: lines |> Enum.map(&parse_line/1)

  def line_snes?(line), do: Regex.match?(@snes_regex, line)

  def parse_line(line) do
    info = Regex.named_captures(@snes_regex, line)
    %{info | "title" => fix_title(info["title"])}
  end

  def fix_title(title) do
    title
    |> String.replace(~r/\(a\)/i, "")
    |> String.replace(~r/\(2 player\)/i, "")
    |> String.replace(~r/\(2p\)/i, "")
    |> String.replace(~r/\(english\)/i, "")
    |> String.replace(~r/\(fan[- ]translation\)/i, "")
    |> String.replace(~r/- Top Gear 3000/i, "Top Gear 3000")
    |> String.replace(~r/Super Punch Out!!/i, "Super Punch Out")
    |> String.replace(~r/Zombies Ate My Neighbours/i, "Zombies Ate My Neighbors")
    |> String.replace(
      ~r/Teenage Mutant Ninja Turtles 4 - Turtles In Time/i,
      "Teenage Mutant Ninja Turtles IV: Turtles in Time"
    )
    |> String.replace(~r/Ghost Chaser Densei - Denjin Makai/i, "Ghost Chaser Densei")
    |> String.replace(~r/Megaman X3/i, "Mega Man X3")
    |> String.replace(~r/King of Dragons/i, "King Of Dragons")
    |> String.replace(
      ~r/Iron Commando: Koutetsu no Senshi/i,
      "Iron Commando - Koutetsu no Senshi"
    )
    |> String.trim()
    |> slugify()
  end

  def slugify(title) do
    title
    |> String.downcase()
    |> String.replace(~r/[^a-zA-Z0-9]/, "-")
    |> String.replace(~r/-+/, "-")
    |> String.replace(~r/(^-|-$)/, "")
  end

  def group_title(games) do
    games
    |> Enum.group_by(fn x -> x["title"] end, fn x -> x["vid"] end)
  end

  def to_list(games_map) do
    games_map
    |> Enum.map(fn {k, v} -> %{title: k, vids: v} end)
    |> Enum.sort_by(fn x -> x[:title] end)
  end
end

FileParser.parse_file("raw-longplay-videos")
|> IO.inspect(limit: :infinity)
|> Term.store("parsed-snes-longplay-vids.bin")

IO.puts(
  "Parsed raw-longplay-videos to a list of maps, and stored in parsed-snes-longplay-vids.bin"
)
