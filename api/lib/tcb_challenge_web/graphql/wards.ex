defmodule TcbChallengeWeb.Graphql.Wards do
  require Logger
  alias TCBChallenge.Socrata
  alias TcbChallengeWeb.Graphql.Utils

  def all_wards(_parent, _args, _resolution) do
    with {:ok, all_wards} <- Socrata.all_wards() do
      # Logger.debug("all_wards: #{inspect all_wards, pretty: true}")
      {:ok, all_wards |> Enum.map(&Utils.ward_keys_as_atoms/1)}
    end
  end

  def fetch_ward(_parent, args, _resolution) do
    ward_id = args[:ward]
    alderman_name = args[:alderman_name]

    result =
      case {ward_id, alderman_name} do
        {nil, nil} ->
          {:error,
           "Neither ward ID nor alderman's name provided as fetch criteria. Provide at least one to fetch ward information."}

        {ward_id, nil} ->
          Socrata.fetch_wards_by_ids(ward_id)

        {nil, alderman_name} ->
          Socrata.fetch_wards_by_alderman(alderman_name)

        {_, _} ->
          {:error,
           "Only ward ID or alderman's name allowed as fetch criteria. Provide at most one to fetch ward information."}
      end

    with {:ok, [ward]} <- result do
      Logger.debug("ward: #{inspect(ward, pretty: true)}")
      {:ok, Utils.ward_keys_as_atoms(ward)}
    else
      {:ok, []} -> {:error, "No wards found."}
      {:ok, wards} -> {:error, "Too many wards found. Expected 1 found #{Enum.count(wards)}."}
      error -> error
    end
  end

  def fetch_wards(_parent, args, _resolution) do
    alderman_name = args[:alderman_name]

    with {:ok, alderman_name} <- required_alderman_name(args),
         {:ok, all_wards} <- Socrata.fetch_wards_by_alderman(alderman_name) do
      {:ok, all_wards |> Enum.map(&Utils.ward_keys_as_atoms/1)}
    end
  end

  defp required_alderman_name(args) do
    if args[:alderman_name] do
      {:ok, args[:alderman_name]}
    else
      {:error, "Alderman partial name is required."}
    end
  end
end
