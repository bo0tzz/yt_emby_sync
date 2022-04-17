defmodule YoutubeDl do
  require Logger

  @download_opts [
                   "--no-simulate",
                   "--newline",
                   "--write-subs",
                   "--embed-chapters",
                   "--no-cache-dir",
                   ["-f", "bestvideo[height<=1080]+bestaudio/best[height<=1080]"],
                   ["--merge-output-format", "mkv"],
                   ["--sub-format", "srt"],
                   ["--sponsorblock-mark", "all"]
                 ]
                 |> List.flatten()

  def info(url) do
    args = ["-J", "--no-cache-dir", url]
    {stdout, 0 = _stderr} = System.cmd(ytdl_binary(), args)
    Jason.decode!(stdout)
  end

  def download(%{"original_url" => url}, path) do
    args =
      @download_opts ++
        [
          "-P",
          path,
          url
        ]

    System.cmd(ytdl_binary(), args, into: IO.stream())
    |> Stream.each(&Logger.debug/1)
  end

  defp ytdl_binary() do
    Application.get_env(:yt_emby_sync, YoutubeDl)[:bin]
  end
end
