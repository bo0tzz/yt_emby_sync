defmodule HttpHandler do
  @behaviour :elli_handler

  require Logger

  @impl :elli_handler
  def handle(req, _args) do
    case :elli_request.method(req) do
      :GET -> handle_get()
      :POST -> handle_post()
    end
  end

  defp handle_get() do
    resp = """
    <html>
      <body>
        <form action="" method="post">
          <button name="submit" value="submit">Run task</button>
        </form>
      </body>
    </html>
    """

    {:ok, [], resp}
  end

  defp handle_post() do
    Logger.info("Got manual task start!")
    Task.async(YtEmbySync, :run, [])
    {:ok, [], "Started task"}
  end

  @impl :elli_handler
  def handle_event(_, _, _), do: :ok
end
