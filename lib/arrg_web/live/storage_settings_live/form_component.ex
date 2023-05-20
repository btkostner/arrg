defmodule ArrgWeb.StorageSettingsLive.FormComponent do
  use ArrgWeb, :live_component

  alias Arrg.Storage

  def render(assigns) do
    assigns = Map.put(assigns, :implementation_options, Arrg.Storage.Implementation.types())

    ~H"""
    <div>
      <.header>
        <%= @file_system.name || "Create new storage" %>
        <:subtitle>Create and update saved storage.</:subtitle>
      </.header>

      <.simple_form for={@form} id="file-system-form" phx-target={@myself} phx-change="validate" phx-submit="save">
        <.input field={@form[:name]} type="text" label="Name" />
        <.input
          field={@form[:type]}
          options={~w(movies shows music)a |> Enum.map(&{&1 |> to_string() |> String.capitalize(), &1})}
          type="select"
          label="Type"
        />

        <%= for implementation_form <- polymorphic_embed_inputs_for @form, :implementation do %>
          <.input
            field={implementation_form[:__type__]}
            options={~w(local)a |> Enum.map(&{&1 |> to_string() |> String.capitalize(), &1})}
            type="select"
            label="Type"
          />

          <%= case get_polymorphic_type(@form, Arrg.Storage.FileSystem, :implementation) do %>
            <% :local -> %>
              <.input field={implementation_form[:root]} type="text" label="Root Path" />
            <% _ -> %>
          <% end %>
        <% end %>

        <:actions>
          <.button phx-disable-with="Saving...">Save Storage</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def update(%{file_system: file_system} = assigns, socket) do
    changeset = Storage.change_file_system(file_system)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  def handle_event("validate", %{"file_system" => file_system_params}, socket) do
    changeset =
      socket.assigns.file_system
      |> Storage.change_file_system(file_system_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"file_system" => file_system_params}, socket) do
    save_file_system(socket, socket.assigns.action, file_system_params)
  end

  defp save_file_system(socket, :edit, file_system_params) do
    case Storage.update_file_system(socket.assigns.file_system, file_system_params) do
      {:ok, file_system} ->
        notify_parent({:saved, file_system})
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_file_system(socket, :new, file_system_params) do
    case Storage.create_file_system(file_system_params) do
      {:ok, file_system} ->
        notify_parent({:saved, file_system})
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
