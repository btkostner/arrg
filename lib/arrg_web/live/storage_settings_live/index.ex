defmodule ArrgWeb.StorageSettingsLive.Index do
  use ArrgWeb, :live_view

  alias Arrg.Storage
  alias Arrg.Storage.FileSystem

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :file_systems, Storage.list_file_systems())}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"name" => name}) do
    socket
    |> assign(:page_title, "Edit Storage")
    |> assign(:file_system, Storage.get_file_system!(name))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Storage")
    |> assign(:file_system, %FileSystem{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Storage")
    |> assign(:file_system, nil)
  end

  def handle_info({ArrgWeb.StorageSettingsLive.FormComponent, {:saved, _file_system}}, socket) do
    {:noreply,
     socket
     |> put_flash(:info, "Storage updated")
     |> push_patch(to: ~p"/settings/storage")
     |> assign(:file_systems, Storage.list_file_systems())}
  end

  def handle_event("delete", %{"name" => name}, socket) do
    file_system = Storage.get_file_system!(name)
    {:ok, _} = Storage.delete_file_system(file_system)

    {:noreply,
     socket
     |> put_flash(:info, "Storage deleted")
     |> assign(:file_systems, Storage.list_file_systems())}
  end
end
