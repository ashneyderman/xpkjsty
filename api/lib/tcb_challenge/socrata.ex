defmodule TCBChallenge.Socrata do
  @moduledoc """
  SOCRATA services. Given our challenge's needs we construct queries with 
  SODA.QueryBuilder and SODA.Query modules then execute HTTP request using 
  HTTPoison.
  """

  import SODA.QueryBuilder
  import SODA.Query
  use Timex
  require Logger

  @doc """
  Retrieves a list of grafitti report items for the list of wards and provided year/month interval.
  """
  def grafitti_counts(wards, {_, _} = start_ym, end_ym) when is_list(wards) do
    grafitti_url = Application.get_env(:tcb_challenge, :grafitti_url)

    ward_ids = wards |> Enum.map(& &1.ward)
    {start_date, end_date} = create_interval(start_ym, end_ym)

    qstring =
      select([
        date_extract_y("creation_date", "year"),
        date_extract_m("creation_date", "month"),
        "ward",
        count()
      ])
      |> where([
        in_("ward", ward_ids),
        between("creation_date", "'#{start_date}'", "'#{end_date}'")
      ])
      |> group_by(["year", "month", "ward"])
      |> query_string()

    do_http_get("#{grafitti_url}.json?#{qstring}")
  end

  def grafitti_counts(ward, {_, _} = start_ym, end_ym) do
    grafitti_counts([ward], start_ym, end_ym)
  end

  def grafitti_counts(ward, {_, _} = start_ym) do
    grafitti_counts(ward, start_ym, nil)
  end

  @doc """
  Fetch information on all wards. We limit fileds to only those
  needed by the challenge.
  """
  def all_wards() do
    ward_url = Application.get_env(:tcb_challenge, :ward_url)

    qstring =
      select(["ward", "alderman"])
      |> limit(1000)
      |> query_string()

    do_http_get("#{ward_url}.json?#{qstring}")
  end

  @doc """
  Fetch ward information where alderman's name partially matches the argument's value.
  """
  def fetch_wards_by_alderman(alderman_name) do
    ward_url = Application.get_env(:tcb_challenge, :ward_url)

    qstring =
      select(["ward", "alderman"])
      |> where(like("alderman", alderman_name))
      |> query_string()

    do_http_get("#{ward_url}.json?#{qstring}")
  end

  @doc """
  Fetch information on all wards by their matching ward numbers.
  """
  def fetch_wards_by_ids([]), do: {:ok, []}

  def fetch_wards_by_ids(ward_ids) when is_list(ward_ids) do
    ward_url = Application.get_env(:tcb_challenge, :ward_url)

    qstring =
      select(["ward", "alderman"])
      |> where(in_("ward", ward_ids))
      |> query_string()

    do_http_get("#{ward_url}.json?#{qstring}")
  end

  def fetch_wards_by_ids(ward_ids), do: fetch_wards_by_ids([ward_ids])

  defp do_http_get(url) do
    api_token = Application.get_env(:tcb_challenge, :socrata_api_token)

    url
    |> HTTPoison.get("X-App-Token": api_token)
    |> case do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        result = Poison.decode!(body)
        # Logger.debug "result: #{inspect result, pretty: true}"
        {:ok, result}

      {:ok, %HTTPoison.Response{} = resp} ->
        {:error, to_error_message(resp)}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp create_interval({start_year, start_month}, end_ym) do
    format = "{YYYY}-{0M}-{0D}T00:00:00.000"
    start_date = Timex.format!({start_year, start_month, 1}, format)

    end_date =
      if end_ym do
        {end_year, end_month} = end_ym

        Timex.format!({end_year, end_month, 1}, format)
        |> Timex.parse!(format)
        |> Timex.shift(months: 1)
        |> Timex.shift(days: -1)
        |> Timex.format!(format)
      else
        Timex.parse!(start_date, format)
        |> Timex.shift(months: 1)
        |> Timex.shift(days: -1)
        |> Timex.format!(format)
      end

    {start_date, end_date}
  end

  defp to_error_message(%HTTPoison.Response{} = r) do
    "#{inspect(r, pretty: true)}"
  end
end
