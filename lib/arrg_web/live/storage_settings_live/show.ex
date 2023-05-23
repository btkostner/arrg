defmodule ArrgWeb.StorageSettingsLive.Show do
  use ArrgWeb, :live_view

  alias Arrg.Storage

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"name" => name}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:file_system, Storage.get_file_system!(name))}
  end

  def handle_info({ArrgWeb.StorageSettingsLive.FormComponent, {:saved, file_system}}, socket) do
    {:noreply,
     socket
     |> put_flash(:info, "Storage updated")
     |> push_patch(to: ~p"/settings/storage/#{file_system}")}
  end

  defp page_title(:show), do: "Show Storage"
  defp page_title(:edit), do: "Edit Storage"
  defp page_title(:scan), do: "Scan Storage"
end
