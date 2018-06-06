defmodule SODA.Query do
  @moduledoc """
  Module that helps constructing SODA $query parameter based on SODA.Query structure.
  """

  defstruct select: [],
            where: [],
            group_by: [],
            limit: nil,
            offset: nil

  def query_string(query) do
    query_string(query, true)
  end
  def query_string(query, true) do
    soda_query = do_query_string(query)
    URI.encode_query(%{"$query" => soda_query})
  end
  def query_string(query, false), do: do_query_string(query)

  defp do_query_string(query) do
    {"", query}
    |> query_select
    |> query_where
    |> query_group_by
    |> query_limit
    |> query_offset
    |> elem(0)
  end

  defp query_select({_, %SODA.Query{ select: [] }=q}), do: { "SELECT *", q }
  defp query_select({_, %SODA.Query{ select: select_fields }=q}) do
    select_stmt = select_fields 
                  |> Enum.map(&select_field/1) 
                  |> Enum.join(",")
    { "SELECT #{select_stmt}", q }
  end

  defp query_where({query_string, %SODA.Query{ where: [] }=q}), do: { query_string, q }
  defp query_where({query_string, %SODA.Query{ where: where_conds }=q}) do
    where_stmt = where_conds 
                  |> Enum.map(&where_cond/1) 
                  |> Enum.join(" AND ")
    new_query_string = [ query_string, "WHERE", where_stmt ] |> Enum.join(" ")
    { new_query_string, q }
  end

  defp query_group_by({query_string, %SODA.Query{ group_by: [] }=q}), do: { query_string, q }
  defp query_group_by({query_string, %SODA.Query{ group_by: group_by_fields }=q}) do
    group_by_stmt = group_by_fields 
                  |> Enum.map(&group_by_field/1) 
                  |> Enum.join(",")
    new_query_string = [ query_string, "GROUP BY", group_by_stmt ] |> Enum.join(" ")
    { new_query_string, q }
  end  

  defp query_limit({query_string, %SODA.Query{ limit: nil }=q}), do: { query_string, q }
  defp query_limit({query_string, %SODA.Query{ limit: limit }=q}) do
    new_query_string = [ query_string, "LIMIT #{limit}" ] |> Enum.join(" ")
    { new_query_string, q }
  end

  defp query_offset({query_string, %SODA.Query{ offset: nil }=q}), do: { query_string, q }
  defp query_offset({query_string, %SODA.Query{ offset: offset }=q}) do
    new_query_string = [ query_string, "OFFSET #{offset}" ] |> Enum.join(" ")
    { new_query_string, q }
  end

  defp select_field({:date_extract_y, field}) when is_binary(field), do: "date_extract_y(#{field})"
  defp select_field({:date_extract_y, field, :as, display}) when is_binary(field) and is_binary(display), do: "date_extract_y(#{field}) AS #{display}"
  defp select_field({:date_extract_m, field}) when is_binary(field), do: "date_extract_m(#{field})" 
  defp select_field({:date_extract_m, field, :as, display}) when is_binary(field) and is_binary(display), do: "date_extract_m(#{field}) AS #{display}"
  defp select_field({:count, field}) when is_binary(field), do: "count(#{field})"
  defp select_field({:count, field, :as, display}) when is_binary(field) and is_binary(display), do: "count(#{field}) AS #{display}"
  defp select_field(field) when is_binary(field), do: field 
  defp select_field({:as, field, display}) when is_binary(field) and is_binary(display), do: "#{field} AS #{display}" 

  defp group_by_field(field) when is_binary(field), do: field
  
  defp where_cond({:eq, field, value}) when is_binary(field), do: "#{field} = #{value}"
  defp where_cond({:like, field, value}) when is_binary(field), do: "#{field} LIKE '%#{value}%'"
  defp where_cond({:between, field, v0, v1}) when is_binary(field), do: "#{field} BETWEEN #{v0} AND #{v1}"
  defp where_cond({:in, field, values}) when is_binary(field) and is_list(values) do
    in_values = values |> Enum.join(",")
    "#{field} in (#{in_values})"
  end

end