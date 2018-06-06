defmodule TcbChallengeWeb.Graphql.Types do
  use Absinthe.Schema.Notation

  @desc "Ward"
  object :ward do
    field :ward, :id
    field :alderman, :string
  end

end