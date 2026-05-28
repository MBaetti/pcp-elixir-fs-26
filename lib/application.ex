# Main-Application

# Haupteinstiegspunkt der Applikation
defmodule PcpElixir.Application do
  use Application

  @impl true
  def start(_type, _args) do
    # Sub-Prozesse registrieren
    children = [
      # Initialzustand [] definieren
      {PcpElixir.Supervisor, []},
      {PcpElixir.APISupervisor, []}
    ]

    # Konfiguration an das OTP-Framework übergeben (Open Telecom Platform/Framework)
    opts = [strategy: :one_for_one]
    Supervisor.start_link(children, opts)
  end
end
