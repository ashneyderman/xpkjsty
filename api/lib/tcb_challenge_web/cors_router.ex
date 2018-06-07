defmodule TcbChallengeWeb.CORSRouter do
  use Corsica.Router,
    origins: "*",
    allow_credentials: true,
    allow_methods: ["POST"],
    allow_headers: :all,
    log: [rejected: :info, invalid: :info],
    max_age: 600

  resource "/*"
end
