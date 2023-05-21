defmodule ArrgWeb.Layouts do
  @moduledoc """
  Templates for the layout of the application.
  """

  use ArrgWeb, :html

  embed_templates "layouts/*"

  @doc """
  Toggles to show the mobile navigation menu.
  """
  def show_mobile_navigation(js \\ %JS{}) do
    js
    |> JS.remove_class("hidden opacity-0",
      to: "#mobile-navigation"
    )
    |> JS.show(
      to: "#mobile-navigation-backdrop",
      transition: {"transition-opacity ease-linear duration-300", "opacity-0", "opacity-100"}
    )
    |> JS.show(
      to: "#mobile-navigation-container",
      transition: {"transition ease-in-out duration-300 transform", "-translate-x-full", "translate-x-0"}
    )
    |> JS.show(
      to: "#mobile-navigation-close",
      transition: {"ease-in-out duration-300", "opacity-0", "opacity-100"}
    )
    |> JS.add_class("overflow-hidden", to: "body")
    |> JS.focus_first(to: "#mobile-navigation")
  end

  @doc """
  Toggles to hide the mobile navigation menu.
  """
  def hide_mobile_navigation(js \\ %JS{}) do
    js
    |> JS.add_class("hidden",
      to: "#mobile-navigation",
      transition: {"transition-opacity ease-linear duration-300", "opacity-100", "opacity-0"}
    )
    |> JS.hide(
      to: "#mobile-navigation-backdrop",
      transition: {"transition-opacity ease-linear duration-300", "opacity-100", "opacity-0"}
    )
    |> JS.hide(
      to: "#mobile-navigation-container",
      transition: {"transition ease-in-out duration-300 transform", "translate-x-0", "-translate-x-full"}
    )
    |> JS.hide(
      to: "#mobile-navigation-close",
      transition: {"ease-in-out duration-300", "opacity-100", "opacity-0"}
    )
    |> JS.remove_class("overflow-hidden", to: "body")
  end

  @doc """
  Checks if the current path matches the given path. If the `:exact` option
  is given, it will only match the exact path. Otherwise, it will match
  any nested path as well.
  """
  def current_link?(assigns, path, opts \\ [])

  def current_link?(%{conn: conn}, path, opts),
    do: current_link?(conn, path, opts)

  def current_link?(%{request_path: request_path}, path, opts),
    do: current_link?(request_path, path, opts)

  def current_link?(current_path, path, opts) do
    if Keyword.get(opts, :exact, false) do
      current_path == path
    else
      String.starts_with?(current_path, path)
    end
  end
end
