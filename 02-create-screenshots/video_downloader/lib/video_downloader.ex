defmodule VideoDownloader do
  use Component.Strategy.Hungry

  def process(%{title: title, vids: vids, data_path: data_path}) do
    game_path = Path.join([data_path, "videos", title])

    unless File.dir?(game_path) do
      File.mkdir_p!(game_path)
    end

    Enum.each(vids, fn vid -> download_vid(game_path, vid) end)
  end

  defp download_vid(game_path, vid) do
    unless file_exists(game_path, vid) do
      IO.puts("Trying to download #{vid}")

      System.cmd("youtube-dl", ["-o", "#{vid}.%(ext)s", "https://www.youtube.com/watch?v=#{vid}"],
        cd: game_path
      )
    end
  end

  defp file_exists(game_path, vid) do
    mkv = Path.join([game_path, "#{vid}.mkv"])
    mp4 = Path.join([game_path, "#{vid}.mp4"])
    File.exists?(mkv) || File.exists?(mp4)
  end
end
