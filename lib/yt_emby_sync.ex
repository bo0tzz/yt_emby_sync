defmodule YtEmbySync do
  require Logger

  def start(:normal, _args) do
    config = Application.get_env(:yt_emby_sync, :targets)

    Logger.info("Retrieving youtube playlist data")
    playlist = config[:youtube_playlist_url] |> YoutubeDl.info()
    videos = playlist["entries"]

    download_videos(videos)

    if Application.get_env(:yt_emby_sync, :destructive) do
      cleanup(playlist)
    end

    System.stop()
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

  def cleanup(playlist) do
    base_path = Files.base_path()

    wanted_directories =
      playlist["entries"]
      |> Enum.map(&Files.sanitized_title/1)
      |> Enum.map(&Path.join(base_path, &1))

    base_path
    |> File.ls!()
    |> Enum.map(&Path.join(base_path, &1))
    |> Enum.reject(&(&1 in wanted_directories))
    |> Enum.filter(&File.dir?/1)
    |> Enum.filter(fn dir ->
      ".yt_emby_sync" in File.ls!(dir)
    end)
    |> tap(&Logger.info("Deleting directories: #{inspect(&1)}"))
    |> Enum.map(&File.rm_rf!/1)
  end
end
