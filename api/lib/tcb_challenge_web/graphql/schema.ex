defmodule TcbChallengeWeb.Graphql.Schema do
  use Absinthe.Schema
  require Logger
  alias TcbChallengeWeb.Graphql.{Wards, Grafitti}

  import_types(Absinthe.Type.Custom)
  import_types(TcbChallengeWeb.Graphql.Types)

  @desc "TCB Challenge Schema"
  query name: "TCBChallenge" do
    @desc "Fetch all wards."
    field :all_wards, list_of(:ward) do
      resolve(&Wards.all_wards/3)
    end

    @desc """
    Fetch ward by either its number or alderman's partial name. Note, an error 
    will be generated if multiple wards are matched, especially when fetching 
    by alderman's partial name. To avoid that provide as much of the matching 
    name as possible to avoid ambiguity or user ward number.
    """
    field :fetch_ward, :ward do
      @desc "ward number"
      arg(:ward, :id)
      @desc "alderman's patial name"
      arg(:alderman_name, :string)
      resolve(&Wards.fetch_ward/3)
    end

    @desc """
    Fetch all wards whith the matching alderman partial name. 
    """
    field :fetch_wards, list_of(:ward) do
      @desc "alderman's patial name"
      arg(:alderman_name, non_null(:string))
      resolve(&Wards.fetch_wards/3)
    end

    @desc """
    Fetch all grafitti request counts for a given combination of arguments.
    Note, that either a list of ward numbers or a list of alderman partial 
    names has to be specified. Partial interval specification can be provided. 
    Default values will be assumed to make a valid interval.
    """
    field :grafitti_report, list_of(:report_item) do
      @desc "list of ward numbers"
      arg(:ward_ids, list_of(:id))
      @desc "list of alderman's patial names"
      arg(:alderman_names, list_of(:string))
      @desc "start year of the report"
      arg(:from_year, non_null(:integer))
      @desc "start month of the report"
      arg(:from_month, :integer)
      @desc "end year of the report"
      arg(:to_year, :integer)
      @desc "end month of the report"
      arg(:to_month, :integer)

      resolve(&Grafitti.grafitti_report/3)
    end
  end
end
