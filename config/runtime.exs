import Config

config :yt_emby_sync, YoutubeDl,
  bin: System.get_env("YTDL_BIN") || System.find_executable("yt-dlp")

config :yt_emby_sync, Files, download_folder: System.fetch_env!("DOWNLOAD_FOLDER")

config :yt_emby_sync, :targets, youtube_playlist_url: System.fetch_env!("YT_PLAYLIST_URL")

config :yt_emby_sync, :destructive, System.get_env("DESTRUCTIVE") != nil

schedule = System.get_env("DOWNLOAD_CRON_SCHEDULE", "*/2 * * * *")

config :yt_emby_sync, YtEmbySync.Scheduler,
  jobs: [
    {schedule, {YtEmbySync, :run, []}}
  ]
