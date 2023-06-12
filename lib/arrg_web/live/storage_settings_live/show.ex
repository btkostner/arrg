defmodule ArrgWeb.StorageSettingsLive.Show do
  use ArrgWeb, :live_view

  alias Arrg.Storage

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"name" => name}, _, socket) do
    file_system = Storage.get_file_system!(name)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:file_system, file_system)
     |> assign(:pid, Storage.get_scan(file_system))}
  end

  def handle_event("scan", _params, socket) do
    %{assigns: %{file_system: file_system}} = socket

    case Storage.create_scan(file_system) do
      {:ok, pid} ->
        Process.monitor(pid)
        {:noreply, assign(socket, :pid, pid)}

      _ ->
        {:noreply, assign(socket, :pid, nil)}
    end
  end

  def handle_info({:DOWN, _ref, :process, pid, _}, %{assigns: %{pid: pid}} = socket) do
    {:noreply, assign(socket, :pid, nil)}
  end

  def handle_info({ArrgWeb.StorageSettingsLive.FormComponent, {:saved, file_system}}, socket) do
    {:noreply,
     socket
     |> put_flash(:info, "Storage updated")
     |> push_patch(to: ~p"/settings/storage/#{file_system}")}
  end

  def handle_info(_info, socket) do
    {:noreply, socket}
  end

  defp page_title(:show), do: "Show Storage"
  defp page_title(:edit), do: "Edit Storage"
end
