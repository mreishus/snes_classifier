#! /usr/bin/env elixir

dupes = [
  {'mega-man-7', 'rockman-7'},
  {'mega-man-x', 'rockman-x'},
  {'mega-man-x2', 'rockman-x2'},
  {'mega-man-x3', 'rockman-x3'},
  {'mighty-morphin-power-rangers-the-movie', 'power-rangers-the-movie'},
  {'puzzle-bobble-bust-a-move', 'bust-a-move'},
  {'castlevania-dracula-x', 'akumajou-dracula-xx'},
  {'kendo-rage', 'makeruna-makendou'},
  {'sd-the-great-battle', 'sd-the-great-battle-aratanaru-chousen'},
  {'euro-football-champ', 'hat-trick-hero'},
  {'cyber-spin', 'shinseiki-gpx-cyber-formula'}
]

defmodule Dupe do
  def process({orig, dupe}) do
    dir = screenshot_dir()
    command1 = 'mv #{dir}/#{dupe}/* #{dir}/#{orig}/'
    command2 = 'rm -rf #{dir}/#{dupe}/'
    :os.cmd(command1)
    :os.cmd(command2)
  end

  def screenshot_dir() do
    dir =
      Path.join(["..", "data", "screenshots"])
      |> Path.expand()

    if !File.dir?(dir) do
      raise "Screenshots dir doesn't exist"
    end

    dir
  end
end

dupes
|> Enum.each(&Dupe.process/1)
