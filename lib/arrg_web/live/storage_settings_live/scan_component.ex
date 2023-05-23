defmodule ArrgWeb.StorageSettingsLive.ScanComponent do
  use ArrgWeb, :live_component

  alias Arrg.Storage

  def render(assigns) do
    ~H"""
    <div>
      <.header>
        Scan <%= @file_system.name %>
        <:subtitle>Syncs the Arrg file database with what currently exists.</:subtitle>
      </.header>
1
      <.simple_form for={@form} id="scan-form" phx-target={@myself} phx-submit="save">
        <%= for file_system_form <- inputs_for @form, :file_system do %>

        <% end %>
        <.input type="hidden" field={@form[:file_system]} value={@file_system.name} />

        <:actions>
          <.button phx-disable-with="Starting Scan...">Scan</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def update(assigns, socket) do
    changeset = Storage.change_scan(%Storage.Scan{})

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  def handle_event("save", %{"scan" => scan_params}, socket) do
    case Storage.create_scan(scan_params) do
      {:ok, scan} ->
        IO.inspect(scan, label: "created scan")
        {:noreply, socket}

      {:error, changeset} ->
        IO.inspect(changeset, label: "full changeset")
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
