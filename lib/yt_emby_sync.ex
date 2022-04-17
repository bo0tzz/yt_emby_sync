defmodule YtEmbySync do
  require Logger

  def start(:normal, _args) do
    config = Application.get_env(:yt_emby_sync, :targets)

    Logger.info("Retrieving youtube playlist data")
    playlist = config[:youtube_playlist_url] |> YoutubeDl.info()
    videos = playlist["entries"]

    download_videos(videos)

    {:ok, self()}
  end

  defp download_videos(videos) do
    Enum.map(videos, &download_video/1)
  end

  defp download_video(video) do
    target_path = Files.target_directory(video)

    if File.exists?(target_path) do
      Logger.info("Video directory #{target_path} already exists - skipping")
    else
      File.mkdir!(target_path)

      target_path
      |> Path.join(".yt_emby_sync")
      |> File.touch!()

      YoutubeDl.download(video, target_path)
    end
  end
end
