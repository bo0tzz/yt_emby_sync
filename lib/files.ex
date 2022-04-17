defmodule Files do
  @illegal_chars ~s(/\\<>:"|?*) |> String.codepoints()

  def target_directory(video) do
    clean = sanitized_title(video)
    Path.join(base_path(), clean)
  end

  def sanitized_title(%{"fulltitle" => title} = _video), do: sanitized_title(title)
  def sanitized_title(title), do: String.replace(title, @illegal_chars, "-")

  def base_path, do: Application.get_env(:yt_emby_sync, Files)[:download_folder]
end
