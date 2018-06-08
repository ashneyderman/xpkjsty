defmodule TcbChallengeWeb.Graphql.Types do
  use Absinthe.Schema.Notation

  @desc "Ward"
  object :ward do
    @desc "Ward number"
    field :ward, :id
    @desc "Alderman's full name"
    field :alderman, :string
  end

  @desc "Grafitti Report Item"
  object :report_item do
    @desc "Ward that the report item is for"
    field :ward,  :ward
    @desc "Number of grafitti requests"
    field :count, :integer
    @desc "Year the report itme is for"
    field :year,  :integer
    @desc "Month the report itme is for"
    field :month, :integer
  end

end