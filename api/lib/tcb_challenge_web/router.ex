defmodule TcbChallengeWeb.Router do
  use TcbChallengeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TcbChallengeWeb do
    pipe_through :api
  end
end
