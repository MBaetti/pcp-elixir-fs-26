# Main-Application

# Haupteinstiegspunkt der Applikation
defmodule PcpElixir.Application do
  use Application

  @impl true
  def start(_type, _args) do
    # Sub-Prozesse registrieren, welche überwacht werden sollen
    children = [
      # Initialzustand [] definieren
      {PcpElixir.Supervisor, []}
    ]

    # Root-Supervisor und definierte Sub-Prozesse darunter starten
    opts = [strategy: :one_for_one]
    Supervisor.start_link(children, opts)
  end
end
