defmodule TcbChallengeWeb.Graphql.Resolvers do
  require Logger
  alias TCBChallenge.Socrata
  
  def all_wards(_parent, _args, _resolution) do
    with {:ok, all_wards} <- Socrata.all_wards() do
      Logger.debug("all_wards: #{inspect all_wards, pretty: true}")
      {:ok, all_wards |> Enum.map(&ward_keys_as_atoms/1)}
    else
      error -> error
    end
  end

  def fetch_ward(_parent, args, _resolution) do
    ward_id = args[:ward]
    alderman_name = args[:alderman_name]
  
    case {ward_id, alderman_name} do
      {nil, nil} ->
        {:error, "Neither ward ID nor alderman's name provided as fetch criteria. Provide at least one to fetch ward information."}
      _ ->
        with {:ok, [ward]} <- Socrata.fetch_ward(ward_id, alderman_name) do
          Logger.debug("ward: #{inspect ward, pretty: true}")
          {:ok, ward_keys_as_atoms(ward)}
        else
          {:ok, []} -> {:error, "No wards found."}
          {:ok, wards} -> {:error, "Too many wards found. Expected 1 found #{Enum.count(wards)}."}
          error  -> error
        end
    end
  end

  def fetch_wards(_parent, args, _resolution) do
    alderman_name = args[:alderman_name]

    with {:ok, all_wards} <- Socrata.fetch_ward(nil, alderman_name) do
      {:ok, all_wards |> Enum.map(&ward_keys_as_atoms/1)}
    else
      error  -> error
    end
  end

  def grafitti_report(_parent, args, _resolution) do
    {:ok, []}
  end

  defp ward_keys_as_atoms(ward_map) do
    %{ 
      alderman: Map.get(ward_map, "alderman"),
      ward: Map.get(ward_map, "ward") 
    }
  end

end