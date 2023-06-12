defmodule ArrgWeb.Router do
  @moduledoc """
  A `Phoenix.Router` instance for the ArrgWeb application.
  """

  use ArrgWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ArrgWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers, %{"content-security-policy" => "default-src 'self'"}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ArrgWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/movies", PageController, :home
    get "/shows", PageController, :home
    get "/music", PageController, :home
    get "/statistics", PageController, :home

    live_session :settings,
      on_mount: [
        {ArrgWeb.RequestPathHook, :on_mount}
      ] do
      live "/settings", SettingsLive.Index, :index

      live "/settings/storage", StorageSettingsLive.Index, :index
      live "/settings/storage/new", StorageSettingsLive.Index, :new
      live "/settings/storage/:name/edit", StorageSettingsLive.Index, :edit

      live "/settings/storage/:name", StorageSettingsLive.Show, :show
      live "/settings/storage/:name/update", StorageSettingsLive.Show, :edit
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", ArrgWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard in development
  if Application.compile_env(:arrg, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ArrgWeb.Telemetry
    end
  end
end
