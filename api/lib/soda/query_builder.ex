defmodule SODA.QueryBuilder do
  @moduledoc """
  Builder that constructs SODA.Query structure. The structure can be used
  to run validations and translation into a SODA query.

  Example:

  iex(1)> limit(10) |> SODA.Query.construct_query_param
  "%24query=SELECT+%2A+LIMIT+10"
  """
  
  def limit(limit) when is_integer(limit) and limit > 0, do: limit(%SODA.Query{}, limit)
  def limit(%SODA.Query{}=q, limit) when is_integer(limit) and limit > 0 do
    %SODA.Query{ q | limit: limit }
  end

  def offset(offset) when is_integer(offset) and offset >= 0 , do: offset(%SODA.Query{}, offset)
  def offset(%SODA.Query{}=q, offset) when is_integer(offset) and offset >= 0 do
    %SODA.Query{ q | offset: offset }
  end

  def select(selection), do: select(%SODA.Query{}, selection)

  def select(%SODA.Query{ select: current }=q, selection) when is_list(selection) do
    %SODA.Query{ q | select: current ++ selection }
  end
  def select(%SODA.Query{}=q, selection), do: select(q, [selection])

  def where(filters), do: where(%SODA.Query{}, filters)

  def where(%SODA.Query{ where: current }=q, filters) when is_list(filters) do
    %SODA.Query{ q | where: current ++ filters }
  end
  def where(%SODA.Query{}=q, filter), do: where(q, [filter])

  def group_by(%SODA.Query{ group_by: current }=q, groupings) when is_list(groupings) do
    %SODA.Query{ q | group_by: current ++ groupings }
  end
  def group_by(%SODA.Query{}=q, grouping), do: group_by(q, [grouping])
  
  def as(field, display) when is_binary(field) and is_binary(display), do: {:as, field, display}

  def date_extract_y(field) when is_binary(field), do: {:date_extract_y, field}
  def date_extract_y(field, display) when is_binary(field) and is_binary(display), do: {:date_extract_y, field, :as, display}

  def date_extract_m(field) when is_binary(field), do: {:date_extract_m, field}
  def date_extract_m(field, display) when is_binary(field) and is_binary(display), do: {:date_extract_m, field, :as, display}

  def count(), do: {:count, "*"}
  def count(field, display) when is_binary(field) and is_binary(display), do: {:count, field, :as, display}

  def eq(field, value) when is_binary(field), do: {:eq, field, value}
  def between(field, start, stop) when is_binary(field), do: {:between, field, start, stop}
  def in_(field, values) when is_binary(field) and is_list(values), do: {:in, field, values}
  def like(field, value) when is_binary(field) and is_binary(value), do: {:like, field, value}
  
end