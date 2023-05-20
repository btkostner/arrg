defmodule ArrgWeb.NavigationComponents do
  @moduledoc """
  Provides UI components for navigation.
  """
  use Phoenix.Component

  import ArrgWeb.CoreComponents, only: [button: 1]
  import ArrgWeb.Layouts, only: [current_link?: 3]

  @doc """
  Renders the secondary navigation bar.

  ## Examples

      <.secondary_nav_bar assigns={assigns}>
        <:item navigate={~p"/"} exact>Home</:item>
        <:item navigate={~p"/page-1"}>Page 1</:item>
        <:item navigate={~p"/page-2"}>Page 2</:item>
      </.secondary_nav_bar>

  """
  attr :assigns, :map, default: %{}
  attr :helper, :string, default: "Select a page"

  slot :item, required: true do
    attr :navigate, :any, required: true
    attr :exact, :boolean
  end

  def secondary_nav_bar(assigns) do
    assigns =
      Map.update(assigns, :item, [], fn item ->
        Enum.map(item, fn item ->
          current? = current_link?(assigns.assigns, item.navigate, exact: Map.get(item, :exact, false))

          Map.put(item, :current?, current?)
        end)
      end)

    ~H"""
    <nav class="border-white/5 flex space-x-4 border-b px-4 py-2" aria-label="Secondary Navigation">
      <.button
        :for={item <- @item}
        navigate={item.navigate}
        variation={if item.current?, do: "contained", else: "text"}
        aria-current={item.current? && "page"}
      >
        <%= render_slot(item) %>
      </.button>
    </nav>
    """
  end
end
