import Config

config :yt_emby_sync, YoutubeDl,
  bin: System.get_env("YTDL_BIN") || System.find_executable("yt-dlp")

config :yt_emby_sync, Files,
  download_folder: System.get_env("DOWNLOAD_FOLDER") || "/Users/boet/tmp/youtube-download"

config :yt_emby_sync, :targets,
  youtube_playlist_url: "https://www.youtube.com/playlist?list=PL3g5xwbQbHORmJmVtwiIjGhGs8RVJZptj"
