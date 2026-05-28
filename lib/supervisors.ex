# Supervisors
# Applikation starten: iex.bat -S mix

# - Praesentation -

# -- Vorbereitung --
# mix.exs unter application mit der Main-Applikation ergänzen: `mod: {PcpElixir.Application, []}`
# Supervisor in lib/application.ex registrieren

# Beispiel basierend auf der 3. Aufgabe aus Modern Java in SW 11
# Weather-Service, welcher Wetterdaten zurückgibt, aber mit einer Wahrscheinlichkeit von 50% fehlschlägt
# Abgespeckte Variante aufgrund der Komplexität (keine 3 Worker)

# - Supervisor -
defmodule PcpElixir.APISupervisor do
  use Supervisor

  # Starten und unter Modulnamen registrieren
  def start_link(init_arg), do: Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)

  @impl true
  def init(_init_arg) do
    # Worker registrieren
    children = [
      {PcpElixir.APIWorker, []}
    ]

    # Konfiguration an das OTP-Framework übergeben
    # :one_for_one -> Stirbt dieser Worker, wird er neu gestartet
    Supervisor.init(children, strategy: :one_for_one)
  end
end

# - Worker -
defmodule PcpElixir.APIWorker do
  use GenServer

  # Starten und unter Modulnamen registrieren
  def start_link(init_arg), do: GenServer.start_link(__MODULE__, init_arg, name: __MODULE__)

  @impl true
  def init(state) do
    # Nachricht an sich selbst, um eine Endlosschleife zu starten
    send(self(), :fetch_weather)
    {:ok, state}
  end

  @impl true
  def handle_info(:fetch_weather, state) do
    # Service aufrufen, Ergebnis ausgeben
    result = PcpElixir.WeatherServiceAPI.call_weather_service()
    IO.inspect(result, label: "Rückmeldung WeatherServiceAPI")

    # Nächste Anfrage in 5 Sekunden asynchron einplanen
    Process.send_after(self(), :fetch_weather, 5000)

    # Rückgabewert
    {:noreply, state}
  end
end

# - Weather-Service -
defmodule PcpElixir.WeatherServiceAPI do
  def call_weather_service do
    # Simulierte Netzwerk-Verzögerung
    :timer.sleep(Enum.random(200..1000))

    # 50% Fehlerwahrscheinlichkeit simulieren
    if :rand.uniform() < 0.5 do
      IO.puts("Fehler beim Abrufen der Wetterdaten")
      :timer.sleep(5000)
      raise "Fehler beim Abrufen der Wetterdaten"
    end

    {:ok, "Sonnig, 25°C"}
  end
end

###################################################################################################

# - Vorbereitung -
# mix.exs unter application mit der Main-Applikation ergänzen: `mod: {PcpElixir.Application, []}`
# Supervisor in lib/application.ex registrieren
# Worker anpingen: PcpElixir.Worker.ping()

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
