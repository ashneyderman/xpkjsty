defmodule TcbChallengeWeb.Graphql.Types do
  use Absinthe.Schema.Notation

  @desc "Ward"
  object :ward do
    field :ward, :id
    field :alderman, :string
  end

  @desc "Grafitti Report Item"
  object :report_item do
    field :ward,  :ward
    field :count, :integer
    field :year,  :integer
    field :month, :integer
  end

end