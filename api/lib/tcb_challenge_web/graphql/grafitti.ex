defmodule TcbChallengeWeb.Graphql.Grafitti do
  require Logger
  alias TCBChallenge.Socrata
  alias TcbChallengeWeb.Graphql.Utils
  use Timex
  
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

    case from_year do
      nil -> {:error, "fromYear is a required parameter"}
      _ -> verify_from_to_arguments({{from_year, from_month}, {to_year, to_month}})
    end
  end

  defp verify_from_to_arguments({{from_year, from_month}, {to_year, to_month}}) do
    from_month = from_month || 1;
    to_year    = to_year || from_year;
    to_month   = to_month || 12;

    format     = "{YYYY}-{0M}-{0D}T00:00:00.000"
    try do
      from_date = Timex.format!({from_year, from_month, 1}, format) |> Timex.parse!(format)
      to_date   = Timex.format!({to_year, to_month, 1}, format) |> Timex.parse!(format)
      if Timex.before?(from_date, to_date) do
        {:ok, {from_year, from_month}, {to_year, to_month}}
      else
        {:error, "Please make sure from comes before the to."}
      end
    catch
      _ -> 
        {:error, "Either from or the to combination of month and year is invalid."}
    end
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