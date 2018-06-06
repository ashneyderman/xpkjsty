defmodule TcbChallengeWeb.Graphql.Grafitti do
  require Logger
  alias TCBChallenge.Socrata
  alias TcbChallengeWeb.Graphql.Utils
  
  def grafitti_report(_parent, args, _resolution) do
    with {:ok, wards, start_ym, end_ym} <- derive_service_arguments(args),
         {:ok, all_items}               <- Socrata.grafitti_counts(wards, start_ym, end_ym) do
      {:ok, all_items 
            |> derive_schema_result(wards)
            |> sort_grafitti_report_items()}   
    end
  end

  defp derive_service_arguments(args) do
    with {:ok, wards}            <- derive_wards_argument(args),
         {:ok, start_ym, end_ym} <- derive_start_and_end_year_month(args) do
      {:ok, wards, start_ym, end_ym}
    end
  end

  defp derive_start_and_end_year_month(args) do
    from_year  = Map.get(args, :from_year)
    from_month = Map.get(args, :from_month)
    to_year    = Map.get(args, :to_year)
    to_month   = Map.get(args, :to_month)

    case {from_year, from_month, to_year, to_month} do
      {nil, _, _, _} -> {:error, "fromYear is a required parameter"}
      {from_year, nil, nil, nil} -> {:ok, {from_year, 1}, {from_year, 12}}
      {from_year, from_month, nil, nil} -> {:ok, {from_year, from_month}, nil}
      {from_year, from_month, to_year, nil} -> {:ok, {from_year, from_month}, {to_year, from_month}}
      _ -> verify_from_to_arguments({:ok, {from_year, from_month}, {to_year, to_month}})
    end
  end

  defp verify_from_to_arguments({_, {_from_year, _from_month}, {_to_year, _to_month}}=r) do
    # TODO: verification.
    r
  end

  defp derive_wards_argument(args) do
    ward_ids       = Map.get(args, :ward_ids, nil)
    alderman_names = Map.get(args, :alderman_names, nil)

    result = case {ward_ids, alderman_names} do
      {nil, nil}            -> {:error, "Either a list of ward IDs or a list of alderman names has to be specified. Neither was specfied."}
      {ward_ids, nil}       -> Socrata.fetch_wards_by_ids(ward_ids)
      {nil, alderman_names} -> derive_wards_from_aldermans(alderman_names)
      {_, _}                -> {:error, "Either a list of ward IDs or a list of alderman names has to be specified. Both at the same can not be specified."}
    end

    with {:ok, wards} <- result do
      {:ok, wards 
            |> Enum.uniq_by(&(&1["ward"]))
            |> Enum.map(&Utils.ward_keys_as_atoms/1)}
    end
  end

  defp derive_wards_from_aldermans(alderman_names) do
    alderman_wards = alderman_names |> Enum.map(&Socrata.fetch_wards_by_ids/1)
    alderman_wards 
    |> Enum.find(&(elem(&1, 0) != :ok)) 
    |> case do
         nil   -> alderman_wards |> Enum.flat_map(&(elem(&1, 1))) 
         error -> error 
       end
  end

  defp derive_schema_result(grafitti_counts, wards) do
    wards_map = wards |> Enum.reduce(%{}, fn(item, acc) -> Map.put(acc, "#{item.ward}", item) end)
    grafitti_counts 
    |> Enum.map(fn(item) -> 
         %{
           year: Map.get(item, "year", 0)   |> Utils.to_int(),
           month: Map.get(item, "month", 0) |> Utils.to_int(),
           count: Map.get(item, "count", 0) |> Utils.to_int(),
           ward: wards_map |> Map.get(Map.get(item, "ward", "-1"), %{})
         }
       end)
  end

  defp sort_grafitti_report_items(all_report_items),
    do: all_report_items |> Enum.sort_by(&{&1.year, &1.month, &1.ward.ward})

end