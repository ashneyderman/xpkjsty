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
  end

end