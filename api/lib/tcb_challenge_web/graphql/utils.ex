defmodule TcbChallengeWeb.Graphql.Utils do

  def to_int(v) when is_integer(v), do: v
  def to_int(v) when is_binary(v) do
    {int, _} = Integer.parse(v)
    int
  end 

  def ward_keys_as_atoms(nil), do: nil
  def ward_keys_as_atoms(ward_map) do
    %{ 
      alderman: Map.get(ward_map, "alderman"),
      ward: Map.get(ward_map, "ward") 
    }
  end

end