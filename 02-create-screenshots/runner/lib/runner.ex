defmodule Runner do
  # use Component.Strategy.Dynamic, top_level: true

  def download_vids do
    data_path = get_data_path()

    get_vids()
    |> Enum.map(fn x -> Map.put(x, :data_path, data_path) end)
    # 18,000 seconds = 300 minutes (Something like final fantasy could download a bunch)
    |> VideoDownloader.consume(timeout: 18_000_000)
  end

  def make_screenshots do
    data_path = get_data_path()

    Path.join([data_path, "videos", "*"])
    |> Path.wildcard()
    |> Enum.filter(&File.dir?/1)
    |> ScreenshotTaker.consume(timeout: 29_000_000)
  end

  defp get_data_path do
    Path.expand("../../data/")
  end

  defp get_vids do
    Term.fetch("../../01-find-longplay-urls/parsed-snes-longplay-vids.bin")
  end
end
