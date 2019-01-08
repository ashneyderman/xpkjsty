defmodule TcbChallengeWeb.ResolverArgsTest do
  use ExUnit.Case, async: true
  alias TcbChallengeWeb.Graphql.{Grafitti, Wards}

  test "grafitti resolver invalid argumetns" do
    assert {:error, _} = Grafitti.grafitti_report(nil, %{}, nil)

    assert {:error, _} =
             Grafitti.grafitti_report(nil, %{ward_ids: ["12"], alderman_names: ["asdfasd"]}, nil)

    assert {:error, _} = Grafitti.grafitti_report(nil, %{ward_ids: ["12"]}, nil)

    assert {:error, _} =
             Grafitti.grafitti_report(
               nil,
               %{ward_ids: ["12"], from_year: 2019, to_year: 2018},
               nil
             )

    assert {:error, _} =
             Grafitti.grafitti_report(
               nil,
               %{ward_ids: ["12"], from_year: 2018, from_month: 12, to_year: 2018, to_month: 6},
               nil
             )
  end

  test "wards resolver invalid arguments" do
    assert {:error, _} = Wards.fetch_ward(nil, %{}, nil)

    assert {:error, _} =
             Wards.fetch_ward(nil, %{ward_ids: ["12"], alderman_names: ["asdfasd"]}, nil)

    assert {:error, _} = Wards.fetch_wards(nil, %{}, nil)
  end
end
