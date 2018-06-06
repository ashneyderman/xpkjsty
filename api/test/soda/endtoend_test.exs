defmodule TcbChallenge.SODA.EndtoendTest do
  use ExUnit.Case, async: true

  import SODA.QueryBuilder
  import SODA.Query

  test "select all wards" do
    assert select(["ward", "alderman"]) |> limit(100) |> offset(50) |> query_string(false) == "SELECT ward,alderman LIMIT 100 OFFSET 50"
    assert select(["ward", "alderman"]) |> where(eq("ward", 14)) |> query_string(false) == "SELECT ward,alderman WHERE ward = 14"
  end

  test "select grafitti by ward and month" do
    # SELECT date_extract_y(creation_date) AS year,
    #        date_extract_m(creation_date) AS month,
    #        location,
    #        status,
    #        what_type_of_surface_is_the_graffiti_on_,
    #        where_is_the_graffiti_located_
    # WHERE ward = 14 AND creation_date BETWEEN '2018-06-01T00:00:00.000' AND '2018-07-01T00:00:00.000'

    base = select(date_extract_y("creation_date", "year"))
           |> select(date_extract_m("creation_date", "month"))
           |> select(["location", "status", "what_type_of_surface_is_the_graffiti_on_", "where_is_the_graffiti_located_"])
           |> where(eq("ward", 14))

    expected = "SELECT date_extract_y(creation_date) AS year,date_extract_m(creation_date) AS month,location,status,what_type_of_surface_is_the_graffiti_on_,where_is_the_graffiti_located_ WHERE ward = 14 AND creation_date BETWEEN '2018-06-01T00:00:00.000' AND '2018-07-01T00:00:00.000'"
    assert (base |> where(between("creation_date", "'2018-06-01T00:00:00.000'", "'2018-07-01T00:00:00.000'")) |> query_string(false)) == expected
  end

end