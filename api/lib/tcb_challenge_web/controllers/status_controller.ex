defmodule TcbChallengeWeb.StatusController do
  use TcbChallengeWeb, :controller
  require TcbChallenge

  def ping(conn, _params) do
    conn
      |> put_status(:ok)
      |> json(%{ resp_type: :pong,
                 version: TcbChallenge.git_hash })
  end

end
