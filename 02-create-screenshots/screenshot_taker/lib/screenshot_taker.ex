defmodule ScreenshotTaker do
  use Component.Strategy.Hungry

  @num_screenshots 150

  def process(vid_dir) do
    screenshot_dir = get_screenshot_dir(vid_dir)
    IO.puts("Process #{vid_dir} -> #{screenshot_dir}")

    vid_files = get_vid_files(vid_dir)

    if length(vid_files) > 0 do
      screenshots_per_file = round(@num_screenshots / length(vid_files))
      screenshots_per_file = screenshots_per_file + length(vid_files) + 2

      vid_files
      |> Enum.each(fn vid_filename ->
        make_screenshots(vid_dir, vid_filename, screenshot_dir, screenshots_per_file)
      end)
    end
  end

  def make_screenshots(vid_dir, vid_filename, screenshot_dir, num_shots) do
    # IO.puts("Making screenshots.  #{vid_dir} #{vid_filename} #{screenshot_dir} #{num_shots}")
    make_dir(screenshot_dir)

    unless has_screenshots?(screenshot_dir, vid_filename) do
      do_make_screenshots(vid_dir, vid_filename, screenshot_dir, num_shots)
    end
  end

  def has_screenshots?(screenshot_dir, vid_filename) do
    vid_filename = Path.basename(vid_filename)

    len =
      Path.join([screenshot_dir, "*" <> vid_filename <> "*"])
      |> Path.wildcard()
      |> length

    len > 0
  end

  def do_make_screenshots(_vid_dir, vid_filename, screenshot_dir, num_shots) do
    # Video Length in seconds
    len = get_vid_length(vid_filename)
    fps = get_vid_fps(vid_filename)

    # Doesn't match up exactly, but seems to work..
    num_frames = fps * len
    screenshot_multi = num_shots / num_frames * fps
    screenshot_multi = :erlang.float_to_binary(screenshot_multi, decimals: 7)

    IO.puts(
      "Length: #{len} FPS: #{fps} Screenshot multi: #{screenshot_multi}.  Trying to get this many screenshots #{
        num_shots
      }"
    )

    IO.puts(
      "ffmpeg -i #{vid_filename} -r #{screenshot_multi} -f image2 -ss 00:00:45.0 #{
        Path.basename(vid_filename)
      }_%05d.jpg"
    )

    a =
      System.cmd(
        "ffmpeg",
        [
          "-i",
          vid_filename,
          "-r",
          screenshot_multi,
          "-f",
          "image2",
          "-ss",
          "00:00:45.0",
          "--",
          "#{Path.basename(vid_filename)}_%05d.jpg"
        ],
        cd: screenshot_dir
      )

    a |> IO.inspect()

    # ffmpeg -i 'SNES Longplay [050] Super Metroid-2mHYOzLh19E.mkv' -r 0.01 -f image2 output_%05d.jpg

    # Making screenshots.  /home/mmr/dev/snes-classifier/data/videos/7th-saga /home/mmr/dev/snes-classifier/data/videos/7th-saga/QA6giKYqtkw.mkv /home/mmr/dev/snes-classifier/data/screenshots/7th-saga 19
  end

  defp get_vid_length(vid_filename) do
    {len_str, 0} =
      System.cmd(
        "ffprobe",
        [
          "-i",
          vid_filename,
          "-show_entries",
          "format=duration",
          "-v",
          "quiet",
          "-of",
          "csv=p=0"
        ]
      )

    {len, _} =
      len_str
      |> String.trim()
      |> Float.parse()

    len
  end

  defp get_vid_fps(vid_filename) do
    {fps_str, 0} =
      System.cmd(
        "ffprobe",
        [
          "-v",
          "0",
          "-of",
          "csv=p=0",
          "-select_streams",
          "v:0",
          "-show_entries",
          "stream=r_frame_rate",
          vid_filename
        ]
      )

    [numer, denom] = fps_str |> String.trim() |> String.split("/")
    {numer, _} = Float.parse(numer)
    {denom, _} = Float.parse(denom)
    numer / denom
  end

  defp make_dir(dir) do
    unless File.dir?(dir) do
      File.mkdir_p!(dir)
    end
  end

  defp get_screenshot_dir(vid_dir) do
    game = Path.basename(vid_dir)

    Path.join([vid_dir, "..", "..", "screenshots", game])
    |> Path.expand()
  end

  defp get_vid_files(vid_dir) do
    Path.join([vid_dir], "*.{mkv,mp4,webm}")
    |> Path.wildcard()
  end
end
