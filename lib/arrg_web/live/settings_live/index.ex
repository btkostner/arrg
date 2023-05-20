defmodule ArrgWeb.SettingsLive.Index do
  use ArrgWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Settings")}
  end
end
