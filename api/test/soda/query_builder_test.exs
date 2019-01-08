defmodule TcbChallenge.SODA.QueryBuilderTest do
  use ExUnit.Case, async: true

  import SODA.QueryBuilder

  test "select work as expected" do
    assert select("ward").select == ["ward"]
    assert (select("ward") |> select("test")).select == ["ward", "test"]
    assert select(count()).select == [{:count, "*"}]
    assert select(count("*", "test")).select == [{:count, "*", :as, "test"}]
    assert select(date_extract_y("field1")).select == [{:date_extract_y, "field1"}]

    assert select(date_extract_y("field1", "myfield")).select == [
             {:date_extract_y, "field1", :as, "myfield"}
           ]

    assert select(date_extract_m("field1")).select == [{:date_extract_m, "field1"}]

    assert select(date_extract_m("field1", "myfield")).select == [
             {:date_extract_m, "field1", :as, "myfield"}
           ]
  end

  test "where works as expected" do
    assert where(eq("ward", 123)).where == [{:eq, "ward", 123}]
    assert where(in_("ward", [123, 345])).where == [{:in, "ward", [123, 345]}]

    assert (where(in_("ward", [123, 345])) |> where(eq("ward", 123))).where == [
             {:in, "ward", [123, 345]},
             {:eq, "ward", 123}
           ]

    assert where(like("alderman", "test")).where == [{:like, "alderman", "test"}]
  end

  test "group_by works as expected" do
    base = select("ward") |> select(count())
    assert (base |> group_by("ward")).group_by == ["ward"]
  end
end
