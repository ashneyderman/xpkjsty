defmodule TcbChallengeWeb.Router do
  use TcbChallengeWeb, :router

  pipeline :api do
    plug Plug.Parsers,
      parsers: [:urlencoded, :multipart, :json, Absinthe.Plug.Parser],
      pass: ["*/*"],
      json_decoder: Poison
  end

  scope "/status" do
    get "/", TcbChallengeWeb.StatusController, :ping
  end

  scope "/api" do
    pipe_through :api
    forward "/", Absinthe.Plug, schema: TcbChallengeWeb.Graphql.Schema
  end

  scope "/" do
    pipe_through :api
    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: TcbChallengeWeb.Graphql.Schema
  end

end
