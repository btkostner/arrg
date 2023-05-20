defmodule ArrgWeb.RequestPathHook do
  @moduledoc """
  Inserts the request path into the socket assigns.
  """

  def on_mount(:on_mount, _params, _session, socket) do
    {:cont,
     Phoenix.LiveView.attach_hook(
       socket,
       :request_path_plug,
       :handle_params,
       &save_request_path/3
     )}
  end

  defp save_request_path(_params, url, socket),
    do: {:cont, Phoenix.Component.assign(socket, :request_path, url |> URI.parse() |> Map.get(:path))}
end
