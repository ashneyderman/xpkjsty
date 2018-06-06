defmodule TCBChallenge.Socrata do
  import SODA.QueryBuilder
  import SODA.Query
  use Timex
  require Logger

  @doc """
  """
  def grafitti_counts(wards, {year, month}) 
      when is_list(wards) and is_integer(year) and is_integer(month) do
    format     = "{YYYY}-{0M}-{0D}T00:00:00.000"
    start_date = Timex.format!({year,month,1}, format)
    end_date   = Timex.parse!(start_date, format) |> Timex.shift(months: 1) |> Timex.shift(days: -1) |> Timex.format!(format)
    qstring    = select([date_extract_y("creation_date", "year"), 
                         date_extract_m("creation_date", "month"), 
                         "ward", 
                         count()])
                 |> where([
                           in_("ward", wards),
                           between("creation_date", "'#{start_date}'", "'#{end_date}'")
                          ])
                 |> group_by(["year", "month", "ward"])
                 |> query_string()

    api_token    = Application.get_env(:tcb_challenge, :socrata_api_token)
    grafitti_url = Application.get_env(:tcb_challenge, :grafitti_url)

    "#{grafitti_url}.json?#{qstring}"
    |> HTTPoison.get(["X-App-Token": api_token])
    |> case do
      {:ok, %HTTPoison.Response{ status_code: 200, body: body }} ->
        {:ok, Poison.decode!(body)}
      {:ok, %HTTPoison.Response{} = resp} ->
        {:error, to_error_message(resp)}
      {:error, %HTTPoison.Error{ reason: reason }} -> 
        {:error, reason}
    end
  end
  def grafitti_report(ward, {year, month} = ym) when is_integer(year) and is_integer(month) do
    grafitti_report([ward], ym)
  end

  def all_wards() do
    api_token    = Application.get_env(:tcb_challenge, :socrata_api_token)
    ward_url = Application.get_env(:tcb_challenge, :ward_url)  
    qstring = select(["ward", "alderman"]) |> limit(1000) |> query_string()

    "#{ward_url}.json?#{qstring}"
    |> HTTPoison.get(["X-App-Token": api_token])
    |> case do
      {:ok, %HTTPoison.Response{ status_code: 200, body: body }} ->
        result = Poison.decode!(body)
        #Logger.debug "all_wards: #{inspect result, pretty: true}"
        {:ok, result}
      {:ok, %HTTPoison.Response{} = resp} ->
        {:error, to_error_message(resp)}
      {:error, %HTTPoison.Error{ reason: reason }} -> 
        {:error, reason}
    end
  end

  defp to_error_message(%HTTPoison.Response{}=r) do
    "#{inspect r, pretty: true}"
  end

end