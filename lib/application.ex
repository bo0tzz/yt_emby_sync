defmodule YtEmbySync.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      YtEmbySync.Scheduler,
      %{
        id: :elli,
        start: {:elli, :start_link, [[callback: HttpHandler]]}
      }
    ]

    opts = [strategy: :one_for_one, name: YtEmbySync.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
