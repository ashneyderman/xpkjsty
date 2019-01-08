defmodule TcbChallenge do
  @moduledoc """
  TcbChallenge keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  defmacro git_hash do
    {hash0, _} = System.cmd("git", ["log", "--pretty=format:\"%h\"", "-n", "1"])
    hash = String.replace(hash0, "\"", "")
    quote do: unquote(hash)
  end
end
