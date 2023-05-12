defmodule ArrgWeb.Layouts do
  use ArrgWeb, :html

  embed_templates "layouts/*"

  def show_mobile_navigation(js \\ %JS{}) do
    js
    |> JS.remove_class("hidden opacity-0",
      to: "#mobile-navigation",
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

  def current_link?(%{request_path: request_path} = conn, path, opts \\ []) do
    if Keyword.get(opts, :exact, false) do
      String.starts_with?(request_path, path)
    else
      request_path == path
    end
  end
end
