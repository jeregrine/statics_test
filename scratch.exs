Mix.install([
  {:bandit, ">= 0.6.9"}

])

defmodule Router do
  use Plug.Router
  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  get "/" do
    send_file(conn, 200, "index.html")
  end

  get "/static/:name" do
    send_resp(conn, 200, "From Elixir: #{name}")
  end

  match _ do
    send_resp(conn, 200, "From Elixir: NOT FOUND")
  end
end

port = String.to_integer(System.get_env("PORT") || "4000")
plug_cowboy = {Bandit, plug: Router, scheme: :http, options: [port: port, transport_options: [ ip: {0, 0, 0, 0, 0, 0, 0, 0}] ] }

require Logger
Logger.info("starting #{inspect(plug_cowboy)}")
{:ok, _} = Supervisor.start_link([plug_cowboy], strategy: :one_for_one)

# unless running from IEx, sleep idenfinitely so we can serve requests
unless IEx.started?() do
  Process.sleep(:infinity)
end

