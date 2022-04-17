defmodule Files do
  @illegal_chars ~s(/\\<>:"|?*) |> String.codepoints()

  def target_directory(%{"fulltitle" => title} = _video) do
    clean = String.replace(title, @illegal_chars, "-")
    Path.join(base_path(), clean)
  end

  defp base_path, do: Application.get_env(:yt_emby_sync, Files)[:download_folder]
end
