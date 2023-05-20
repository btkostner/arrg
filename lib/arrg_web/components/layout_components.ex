defmodule ArrgWeb.LayoutComponents do
  @moduledoc """
  Components related to layouts and spacing.
  """
  use Phoenix.Component

  import ArrgWeb.CoreComponents, only: [icon: 1]
  import ArrgWeb.Gettext

  @doc """
  An empty space used to show no data.
  """
  attr :icon, :string, required: true

  slot :inner_block, required: true
  slot :subtitle
  slot :action

  def blank_space(assigns) do
    ~H"""
    <div class="py-24 text-center">
      <.icon name={@icon} class="mx-auto h-12 w-12 text-gray-700" />

      <h3 class="mt-2 text-2xl font-bold leading-7 text-white sm:truncate sm:text-3xl sm:tracking-tight">
        <%= render_slot(@inner_block) %>
      </h3>

      <p :if={@subtitle != []} class="mt-4 text-sm text-gray-500">
        <%= render_slot(@subtitle) %>
      </p>

      <div :if={@action != []} class="mt-6">
        <%= for action <- @action do %>
          <%= render_slot(action) %>
        <% end %>
      </div>
    </div>
    """
  end

  @doc """
  Marks an unimplemented feature with a blank space.
  """
  def unimplemented_space(assigns) do
    ~H"""
    <.blank_space icon="hero-exclamation-circle">
      <%= gettext("Unimplemented") %>
      <:subtitle><%= gettext("This feature is not yet implemented.") %></:subtitle>
    </.blank_space>
    """
  end
end
