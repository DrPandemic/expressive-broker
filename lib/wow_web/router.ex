defmodule WowWeb.Router do
  use WowWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", WowWeb do
    pipe_through :browser

    get "/", HomeController, :index
    get "/items", ItemController, :show
  end

  scope "/api", WowWeb do
    pipe_through :api

    get "/items", ItemController, :show_json
    get "/items/find", ItemController, :find

    get "/home/present", HomeController, :present
    get "/home/expensive", HomeController, :expensive
  end
end
