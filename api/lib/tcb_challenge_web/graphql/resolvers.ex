defmodule TcbChallengeWeb.Graphql.Resolvers do
  require Logger
  alias TCBChallenge.Socrata
  
  def all_wards(_parent, _args, _resolution) do
    r = Socrata.all_wards() |> elem(1) |> Enum.map(fn(e) -> 
      %{ alderman: Map.get(e, "alderman"),
         ward: Map.get(e, "ward") }
    end)
    Logger.debug("r: #{inspect r, pretty: true}")
    {:ok, r}
  end

  

end