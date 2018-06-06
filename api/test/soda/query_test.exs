defmodule TcbChallenge.SODA.QueryTest do
  use ExUnit.Case, async: true

  import SODA.Query

  test "constructs select properly" do
    assert %SODA.Query{ select: ["ward", {:count, "*", :as, "test"}] } |> query_string(false) == "SELECT ward,count(*) AS test"
    assert %SODA.Query{ select: ["ward", {:count, "*"}] } |> query_string(false) == "SELECT ward,count(*)"
    assert %SODA.Query{ select: [{:as, "ward", "test"}] } |> query_string(false) == "SELECT ward AS test"
  end

  test "constructs where properly" do
    assert %SODA.Query{ where: [{:eq, "ward", 123}] } |> query_string(false) == "SELECT * WHERE ward = 123"
    assert %SODA.Query{ where: [{:in, "ward", [123, 345]}] } |> query_string(false) == "SELECT * WHERE ward in (123,345)"
    assert %SODA.Query{ where: [{:between, "ward", 123, 345}] } |> query_string(false) == "SELECT * WHERE ward BETWEEN 123 AND 345"
    assert %SODA.Query{ where: [{:like, "alderman", "test"}] } |> query_string(false) == "SELECT * WHERE alderman LIKE '%test%'"
  end

  test "constructs limit/offset/group_by properly" do
    assert %SODA.Query{ limit: 123 } |> query_string(false) == "SELECT * LIMIT 123"
    assert %SODA.Query{ offset: 123 } |> query_string(false) == "SELECT * OFFSET 123"
    assert %SODA.Query{ group_by: ["ward"] } |> query_string(false) == "SELECT * GROUP BY ward" # note this query is syntactically wrong
  end

end