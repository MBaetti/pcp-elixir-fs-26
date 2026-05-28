# Supervisors
# Interaktive Shell starten: iex.bat -S mix
# Worker anpingen: PcpElixir.APIWorker.getWeather()

# - Praesentation -

# -- Vorbereitung --
# mix.exs unter application mit der Main-Applikation ergänzen: `mod: {PcpElixir.Application, []}`
# Supervisor in lib/application.ex registrieren

# Beispiel anhand der 3. Aufgabe in der Modern Java Woche 2
# Weather-Service, welcher Wetterdaten zurückgibt, aber mit einer Wahrscheinlichkeit von 50% fehlschlägt

# - Supervisor -
defmodule PcpElixir.APISupervisor do
  use Supervisor

  # Supervisor starten und unter eigenem Namen registrieren
  def start_link(init_arg), do: Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)

  # Nach dem Starten initialisieren
  def init(_init_arg) do
    # 3 API-Worker registrieren
    children =
      Enum.map(1..3, fn index ->
        name = :"api_worker_#{index}"
        Supervisor.child_spec({PcpElixir.APIWorker, {index, name}}, id: name)
      end)

    # Supervisor und registrierte Worker
    Supervisor.init(children, strategy: :one_for_one)
  end
end

# - Worker -
defmodule PcpElixir.APIWorker do
  use GenServer

  # Worker starten und unter eigenem Namen registrieren
  def start_link({_, name} = arg), do: GenServer.start_link(__MODULE__, arg, name: name)

  # Nach dem Starten initialisieren
  def init(state), do: {:ok, state}

  # Asynchrone Nachricht an diesen Worker und warten auf Antwort
  def getWeather do
    1..3
    |> Enum.map(
      &Task.async(fn ->
        try do
          GenServer.call(:"api_worker_#{&1}", :getWeather)
        catch
          # Fängt das EXIT-Signal des abstürzenden Workers ab und verhindert, dass der aufrufende Prozess ebenfalls abstürzt
          :exit, _ -> {:error, :worker_crashed}
        end
      end)
    )
    |> Enum.map(&Task.await/1)
  end

  # Empfängt Nachricht und schickt Ergebnis zurück
  def handle_call(:getWeather, _from, state) do
    # Simulierten externen Service Aufruf
    {:reply, PcpElixir.WeatherService.call_weather_service(), state}
  end
end

# - Weather-Service -
defmodule PcpElixir.WeatherService do
  # Simuliert einen externen Service, welcher Wetterdaten zurückgibt
  def call_weather_service do
    # Simulierte Verzögerung
    :timer.sleep(Enum.random(200..1000))

    # Schlägt mit einer Wahrscheinlichkeit von 50% fehl
    if :rand.uniform() < 0.5 do
      raise "Fehler beim Abrufen der Wetterdaten"
    end

    # Simulierte Wetterdaten
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
