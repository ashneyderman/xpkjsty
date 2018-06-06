defmodule TcbChallengeWeb.Graphql.Schema do
  use Absinthe.Schema
  require Logger
  alias TcbChallengeWeb.Graphql.{Resolvers}
  
  import_types Absinthe.Type.Custom
  import_types TcbChallengeWeb.Graphql.Types
  
  @desc "TCB Challenge Schema"
  query name: "TCBChallenge" do
    @desc "Fetch current user's profile"
    field :all_wards, list_of(:ward) do
      resolve &Resolvers.all_wards/3
    end

    field :fetch_ward, :ward do
      arg :ward, :id
      arg :alderman_name, :string
      resolve &Resolvers.fetch_ward/3
    end

    field :fetch_wards, list_of(:ward) do
      arg :alderman_name, non_null(:string)
      resolve &Resolvers.fetch_wards/3
    end

    field :grafitti_report, list_of(:report_item) do
      arg :ward_ids, list_of(:id)
      arg :alderman_names, list_of(:string)
      arg :from_year, non_null(:integer)
      arg :from_month, non_null(:integer)
      arg :to_year, :integer
      arg :to_month, :integer 

      resolve &Resolvers.grafitti_reports/3
    end 
  end

end