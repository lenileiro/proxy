defmodule Proxy do
  use Plug.Router
  alias Proxy.ObjectStore
  alias Proxy.Logger

  require Logger

  plug(Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["text/*"],
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  get "/:tenant_id/:blob_id" do

    request = conn.params

    Logger.save_event(request)

    %{"blob_id" => blob_id} = request

      ObjectStore.get_blob_file_by_id(blob_id)
      |> case do
        {:ok, contents} ->
          send_resp(conn, 200, contents)
        _->
          conn = %{conn | resp_headers: [{"content-type", "text/plain"}]}
          send_resp(conn, 401, "contents Not Found")
      end
  end

  match(_, do: send_resp(conn, 404, "404 error not found"))
end
