# Elixir – Team Bericht

- **Autoren:** Maurice Bättig & Mathias Vogel 
- **Modul:** PCP – Programmierkonzepte und Paradigmen  
- **Datum:** Mai 2026
- **GitHub-Repo:** https://github.com/MBaetti/pcp-elixir-fs-26.git

## 1. Was ist Elixir?

Elixir ist eine Programmiersprache mit folgenden Eigenschaften:
- **Funktional:** Code wird durch Funktionen strukturiert
- **Dynamisch typisiert:** Typen werden zur Laufzeit geprüft
- **Läuft auf der BEAM VM:** Dieselbe VM wie Erlang
- **Immutable:** Daten können nach der Erstellung nicht verändert werden
- **Pattern Matching:** Mächtiges Werkzeug statt if/else Ketten
- **Actor Model:** Concurrency ohne shared state

Elixir wurde 2012 von José Valim entwickelt. Sein Ziel war es, die Eleganz und Produktivität von Ruby mit der bewährten Nebenläufigkeitsinfrastruktur der Erlang VM (BEAM) zu kombinieren. Der Hauptgrund war, dass Ruby unter dem Global Interpreter Lock (GIL) leidet, der echte Parallelität auf Multicore-Systemen verhindert. Elixir löst dieses Problem, ohne auf Entwicklerfreundlichkeit zu verzichten.

Elixir wird heute von namhaften Unternehmen produktiv eingesetzt:
- **Discord:** Chat-Infrastruktur für über 100 Millionen Nutzer
- **Pinterest:** Backend-Services für Push Notifications und Echtzeit-Analytics

## 3. Fokuspunkte

### 3.1 Comprehensions & Pipe-Operator

- **Quellcode-Referenz:** lib/comprehensions.exs, Beispiele anhand des Demo-Codes SW09 Java: Lambda-Beispiel

Comprehensions sind ein Sprachkonstrukt zum Filtern und Transformieren von Collections. Eine Comprehension besteht aus drei Teilen: 

`for [GENERATOR], [FILTERS], do: [TRANSFORMATION]`

`for x <- [1, 2, 3], x > 2, do: x * 2`

#### 3.1.1 Generator

Definiert die Collection über die iteriert wird: 
`for x <- [1, 2, 3]`

#### 3.1.2 Filter-Klauseln (optional)

Definiert Bedingungen für Elemente:
`x > 2`

#### 3.1.3 do / Transformation

Definiert was mit jedem Element gemacht wird:
`do: x * 2`

Standardmässig gibt eine Comprehension immer eine Liste zurück. Mit `:into` kann das Ergebnis direkt in eine andere Datenstruktur gesammelt werden:

`numberResult = for x <- [1, 2, 2, 3, 3], into: MapSet.new(), do: x`

#### 3.1.4 Pipe-Operator

Der Pipe-Operator `|>` übergibt das Ergebnis eines Ausdrucks als erstes Argument an die nächste Funktion. Dies ermöglicht lesbare Transformationsketten ohne Verschachtelung:
```elixir
# Ohne Pipe – von innen nach aussen lesen
String.upcase(String.trim("  hello world  "))
# Mit Pipe – von oben nach unten lesen
"  hello world  "
|> String.trim()
|> String.upcase()
```

### 3.2 Concurrency – The Actor Model

- **Quellcode-Referenz:** lib/concurrency.exs, Beispiel anhand des Demo-Codes SW09 Java: CompletableFuture "in Action"

Das Actor Model ist das zentrale Concurrency-Paradigma in Elixir. Jeder Prozess ist ein unabhängiger Actor mit:
- **eigenem State:** Niemand anderes kann ihn direkt lesen/ändern
- **einer Mailbox:** Warteschlange für eingehende Messages
- **einem Verhalten:** Wie er auf Messages reagiert

Kommunikation erfolgt ausschliesslich über Messages. Es gibt keinen shared state und damit keine Race Conditions. Im Vergleich zu Java Threads sind Elixir Prozesse extrem leichtgewichtig. Dadurch sind Millionen gleichzeitiger Prozesse möglich.

```elixir
# Neuen Prozess erstellen, gibt eine PID (Prozess-ID) zurück
pid = spawn(fn ->
  receive do
    {:hello, msg} -> IO.puts("Got: #{msg}")  # wartet auf Message
  end
end)
# Message an den Prozess senden via PID
send(pid, {:hello, "World"})
```

- **Task:** Für einmalige asynchrone Aufgaben mit Rückgabewert. Im Gegensatz zu spawn kann der Rückgabewert direkt abgerufen werden.
- **Agent:** Einfacher Prozess für shared state. Kapselt einen Zustand und ermöglicht synchronen Zugriff darauf.
- **Link:** Verbindet zwei Prozesse bidirektional. Stirbt einer, wird der andere ebenfalls beendet.
- **Monitor:** Beobachtet einen Prozess unidirektional. Stirbt der beobachtete Prozess, erhält der Monitor eine Nachricht und läuft weiter.

### 3.3 OTP Supervisors

- **Quellcode-Referenz:** lib/supervisors.ex, Beispiel anhand des Demo-Codes SW11 Modern Java: 3. Aufgabe

Ein Kernkonzept zur Fehlerbehandlung nach der «Let it crash»-Philosophie. Anstatt Fehler defensiv abzufangen, lässt man fehlerhafte Prozesse sofort abstürzen. Ein übergeordneter Überwachungsprozess (Supervisor) registriert diesen Ausfall und startet den betroffenen Worker automatisch in einem sauberen Ausgangszustand neu. Im Gegensatz zu Java, wo eine Exception in einem Thread die gesamte Applikation zum Abstürzen bringen kann, bleiben Elixir-Systeme dadurch dauerhaft stabil.

#### 3.3.1 Neustart-Strategien

- **one_for_one:** Nur der spezifisch abgestürzte Worker wird neu gestartet.
- **one_for_all:** Alle vom betroffenen Supervisor verwalteten Prozesse werden neu gestartet.
- **rest_for_one:** Der abgestürzte Worker sowie alle in der Startreihenfolge nachfolgenden Prozesse werden neu gestartet.

### 3.4 Metaprogramming – Macros & Quotes

- **Quellcode-Referenz:** lib/metaprogramming.exs

Metaprogrammierung beschreibt den Mechanismus, bei dem Quellcode in seinen abstrakten Syntaxbaum umgewandelt wird. Dies erlaubt es, Code bereits zur Kompilierzeit programmatisch zu verändern oder die Sprache selbst zu erweitern.

#### 3.4.1 Kernkonstrukte

- **quote:** Nimmt Elixir-Code entgegen und gibt dessen Struktur (bestehend aus Operator, Metadaten und Funktionsargumenten) zurück, ohne ihn dabei auszuführen.
- **unquote:** Wird innerhalb von quote verwendet, um Werte dynamisch einzufügen und diese bereits zur Compilezeit auszuwerten.

#### 3.4.2 Macros

Macros kombinieren diese Konstrukte und werden vor allem eingesetzt für:
- Spracherweiterungen und die Entwicklung eigener Domain Specific Languages (DSLs).
- Das Auslagern von aufwendigen Berechnungen in die Compile-Zeit zur Leistungsoptimierung.
- Lazy Evaluation (z. B. das Auswerten eines übergebenen Code-Blocks nur dann, wenn eine bestimmte Bedingung zutrifft).

## 4. Technisches Team-Fazit

\+ Effizient, da basierend auf der Erlang VM </br>
\+ Concurrency ohne Locks und damit eleganter als Java Threads </br>
\+ Pipe-Operator und Comprehensions füren zu sehr lesbarem Code </br>
\+ «Let it crash» als effektiver Paradigmenwechsel

\- Dynamische Typen, also keine Compile-Time Type Safety </br>
\- Kleineres Ökosystem als Java </br>
\- Komplexes Supervisor-Konzept mit erhöhtem Konfigurationsaufwand

## 5. Persönliches Fazit

### 5.1 Maurice Bättig

Obwohl Elixir viele spannende Konzepte bietet, erweist sich der Einstieg im direkten Vergleich zu Clojure als etwas mühsam. Bereits das initiale Aufsetzen eines Projekts ist durch die zwingend benötigten Komponenten wie Erlang, Elixir und entsprechende VS Code-Plugins eher aufwändig. Auch das Ausführen von Code gestaltet sich in der Praxis weniger simpel und direkt, selbst unter Berücksichtigung der spezifischen Datei-Endungen (.ex für kompilierte und .exs für Skript-Dateien). 

Ein echtes Highlight der Sprache ist zweifellos das «Let it crash»-Konzept, allerdings geht dieses mächtige Werkzeug mit einer hohen Komplexität und einem nicht zu unterschätzenden Konfigurationsaufwand einher.

### 5.2 Mathias Vogel

Ich finde Elixir eine sehr interessante Sprache. Die Art wie Concurrency implementiert wurde gefällt mir sehr, da jeder Prozess unabhängig von den anderen läuft und der Code dadurch übersichtlich und sicher bleibt. Auch der Pipe-Operator hat mich überzeugt. Ähnlich wie Java Streams ermöglicht er es, Folgeoperationen sauber und lesbar darzustellen.

Was mich weniger überzeugt hat, ist die Möglichkeit verschiedene Typen direkt miteinander zu vergleichen. Es ist mir nicht ganz klar wo man das sinnvoll einsetzen würde, trotzdem muss man es kennen um fremden Code verstehen zu können.

Ein abschliessendes Fazit ist jedoch schwierig zu ziehen, da wir hauptsächlich kurze, unabhängige Scripts programmiert haben. Wie sich die Sprache in einem grösseren Projekt anfühlt, bleibt offen.

## 6. Quellen

- Elixir Official Documentation (The Elixir Team, 2026): https://elixir-lang.org/docs.html
- Elixir School (Sean Callan, 2021): https://elixirschool.com
- Discord Engineering Blog (José Valim, 01.08.2020): https://elixir-lang.org/blog/2020/10/08/real-time-communication-at-scale-with-elixir-at-discord/
- Paraxial Blog (Michael Lubas, 28.08.2023): https://paraxial.io/blog/elixir-savings