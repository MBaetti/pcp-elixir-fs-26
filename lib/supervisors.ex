# Supervisors

# - Vorbereitung -
# mix.exs unter application mit der Main-Applikation ergänzen: `mod: {PcpElixir.Application, []}`
# Supervisor in lib/application.ex registrieren

# Modul mit Supervisor-Verhalten (überwacht Prozesse, startet sie neu, etc.)
defmodule PcpElixir.Supervisor do
  use Supervisor

  # Startet den Supervisor-Prozess und registriert ihn unter seinem eigenen Modulnamen
  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  # Supervisor nach dem Starten initialisieren
  def init(_init_arg) do
    # Worker-Prozesse registrieren, welche überwacht werden sollen
    children = [
      # Initialzustand [] definieren
      {PcpElixir.Worker, []}
    ]

    # Supervisor und definierte Worker-Prozesse darunter starten
    Supervisor.init(children, strategy: :one_for_one)
  end
end

# Worker-Prozess, welcher das Actor-Modell implementiert (isolierter Prozess mit eigenem Zustand)
defmodule PcpElixir.Worker do
  use GenServer

  # Startet den Worker und registriert ihn unter seinem eigenen Modulnamen
  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  # Worker nach dem Starten initialisieren
  def init(state) do
    {:ok, state}
  end

  # Schickt synchron eine Nachricht (:ping) an diesen spezifischen Prozess und wartet auf Antwort
  # Läuft auf dem aufrufenden Prozess (GenServer.call)
  def ping do
    GenServer.call(__MODULE__, :ping)
  end

  # Empfängt die Nachricht :ping, schickt :pong an den Aufrufer zurück
  # Läuft auf dem Worker-Prozess
  def handle_call(:ping, _from, state) do
    {:reply, :pong, state}
  end
end

# Interaktive Shell starten: iex.bat -S mix
# Worker anpingen: PcpElixir.Worker.ping()
