defmodule BlankDeleter do
  use Component.Strategy.Hungry

  def process(filename) do
    if blank?(filename) do
      # mean = get_mean(filename)
      # IO.puts(filename <> " " <> Float.to_string(mean))
      IO.puts("Deleting " <> filename)
      File.rm!(filename)
    end
  end

  defp get_mean(filename) do
    {mean_str, 0} =
      System.cmd(
        "convert",
        [
          filename,
          "-format",
          "%[mean]",
          "info:"
        ]
      )

    {mean, _} =
      mean_str
      |> String.trim()
      |> Float.parse()

    mean
  end

  defp blank?(filename) do
    get_mean(filename) == 0
  end
end
