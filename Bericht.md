# Elixir – Team Bericht

**Autoren:** Maurice Bättig & Mathias Vogel 

**Modul:** PCP – Programmierkonzepte und Paradigmen  

**Datum:** Mai 2026  

---

## 1. Einleitung

### Was ist Elixir?

Elixir ist eine Programmiersprache mit folgenden Eigenschaften:

- **Funktional** – Code wird durch Funktionen strukturiert
- **Dynamisch typisiert** – Typen werden zur Laufzeit geprüft
- **Läuft auf der BEAM VM** – dieselbe VM wie Erlang
- **Immutable** – Daten können nach der Erstellung nicht verändert werden
- **Pattern Matching** – mächtiges Werkzeug statt if/else Ketten
- **Actor Model** – Concurrency ohne shared state

### Geschichte & Vision

Elixir wurde 2012 von José Valim entwickelt, einem bekannten Ruby-on-Rails-Core-Contributor. Sein Ziel war es, die Eleganz und Produktivität von Ruby mit der bewährten Nebenläufigkeitsinfrastruktur der Erlang VM (BEAM) zu kombinieren. Der Hauptgrund: Ruby leidet unter dem Global Interpreter Lock (GIL), der echte Parallelität auf Multicore-Systemen verhindert. Elixir löst dieses Problem, ohne auf Entwicklerfreundlichkeit zu verzichten.

### Verbreitung

Elixir wird heute von namhaften Unternehmen produktiv eingesetzt:

- **Discord** – Chat-Infrastruktur für über 100 Millionen Nutzer
- **Pinterest** – Backend-Services für Push Notifications und Echtzeit-Analytics

---
## 2. Interessant anders

### Typvergleiche
In Elixir können verschiedene Datentypen direkt miteinander verglichen werden. Dafür gibt es eine globale Sortierreihenfolge:
```elixir
number < atom < tuple < map < list < bitstring

"25" > 23    # => true
```

### Enum
In Elixir ist `Enum` ein Modul mit Funktionen zum Verarbeiten von Collections:

```elixir
Enum.map([1, 2, 3], fn x -> x * 2 end)    # => [2, 4, 6]
Enum.filter([1, 2, 3], fn x -> x > 1 end) # => [2, 3]
```
---

## 3. Fokuspunkte

### 3.1 Comprehensions & Pipe-Operator

Comprehensions sind ein Sprachkonstrukt zum Filtern und Transformieren von Collections. Eine Comprehension besteht aus drei Teilen: `for [GENERATOR], [FILTERS], do: [TRANSFORMATION]`

```elixir
for x <- [1, 2, 3], x > 2, do: x * 2
# [6]
```

**Generator** – definiert die Collection über die iteriert wird:
```elixir
for x <- [1, 2, 3]
```

**Filter-Klauseln** (optional) – definiert Bedingungen für Elemente:
```elixir
x > 2
```

**do / Transformation** – definiert was mit jedem Element gemacht wird:
```elixir
do: x * 2
```
Standardmässig gibt eine Comprehension immer eine Liste zurück. Mit `:into` kann das Ergebnis direkt in eine andere Datenstruktur gesammelt werden:

```elixir
numberResult = for x <- [1, 2, 2, 3, 3], into: MapSet.new(), do: x
# MapSet.new([1, 2, 3])
```
#### 3.1.1 Pipe-Operator

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
Das Actor Model ist das zentrale Concurrency-Paradigma in Elixir. Jeder Prozess ist ein unabhängiger Actor mit:

- eigenem **State** – niemand anderes kann ihn direkt lesen/ändern
- einer **Mailbox** – Warteschlange für eingehende Messages
- einem **Verhalten** – wie er auf Messages reagiert

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

**Task** – für einmalige asynchrone Aufgaben mit Rückgabewert. Im Gegensatz zu spawn kann der Rückgabewert direkt abgerufen werden.

**Agent** – einfacher Prozess für shared state. Kapselt einen Zustand und ermöglicht synchronen Zugriff darauf.

**Link** – verbindet zwei Prozesse bidirektional. Stirbt einer, wird der andere ebenfalls beendet.

**Monitor** – beobachtet einen Prozess unidirektional. Stirbt der beobachtete Prozess, erhält der Monitor eine Nachricht und läuft weiter.

### 3.3 OTP Supervisors

Ein Kernkonzept zur Fehlerbehandlung nach der «Let it crash»-Philosophie. Anstatt Fehler defensiv abzufangen, lässt man fehlerhafte Prozesse sofort abstürzen. Ein übergeordneter Überwachungsprozess (Supervisor) registriert diesen Ausfall und startet den betroffenen Worker automatisch in einem sauberen Ausgangszustand neu. Im Gegensatz zu Java, wo eine Exception in einem Thread die gesamte Applikation zum Abstürzen bringen kann, bleiben Elixir-Systeme dadurch dauerhaft stabil.

Mögliche Neustart-Strategien:
- :one_for_one: Nur der spezifisch abgestürzte Worker wird neu gestartet.
- :one_for_all: Alle vom betroffenen Supervisor verwalteten Prozesse werden neu gestartet.
- :rest_for_one: Der abgestürzte Worker sowie alle in der Startreihenfolge nachfolgenden Prozesse werden neu gestartet.

Quellcode-Referenz: Skript lib/supervisors.ex, mit Beispiel basierend auf der 3. Aufgabe aus Modern Java in SW 11.

### 3.4 Metaprogramming – Macros & Quotes

Metaprogrammierung beschreibt den Mechanismus, bei dem Quellcode in seinen abstrakten Syntaxbaum umgewandelt wird. Dies erlaubt es, Code bereits zur Kompilierzeit programmatisch zu verändern oder die Sprache selbst zu erweitern.

Die Kernwerkzeuge:
- quote – Nimmt Elixir-Code entgegen und gibt dessen Struktur (bestehend aus Operator, Metadaten und Funktionsargumenten) zurück, ohne ihn dabei auszuführen.
- unquote – Wird innerhalb von quote verwendet, um Werte dynamisch einzufügen und diese bereits zur Compilezeit auszuwerten.

Macros:
Macros kombinieren diese Konstrukte und werden vor allem eingesetzt für:
- Spracherweiterungen und die Entwicklung eigener Domain Specific Languages (DSLs).
- Das Auslagern von aufwendigen Berechnungen in die Compile-Zeit zur Leistungsoptimierung.
- Lazy Evaluation (z. B. das Auswerten eines übergebenen Code-Blocks nur dann, wenn eine bestimmte Bedingung zutrifft).

Quellcode-Referenz: Skript lib/metaprogramming.exs

## 4. Technisches Team-Fazit


**Stärken:**
- Concurrency ohne Locks – eleganter als Java Threads
- Pipe-Operator und Comprehensions → sehr lesbarer Code
- «Let it crash» ist ein radikaler aber effektiver Paradigmenwechsel

**Schwächen:**
- Steile Lernkurve (funktional + OTP-Konzepte)
- Dynamische Typen – kein Compile-Time Type Safety
- Kleineres Ökosystem als Java

---

## 5. Persönliches Fazit

### Maurice Bättig

- Ausführen von Code nicht so simple wie bei Clojure
- Supervisor als cooles Feature, jedoch komplex und mit viel Konfigurationsaufwand

### Mathias Vogel

Ich finde Elixir eine sehr interessante Sprache. Besonders beeindruckend ist die Möglichkeit, tausende von Prozessen parallel laufen zu lassen, ohne dabei an Performance zu verlieren. Die Art wie Concurrency implementiert wurde gefällt mir sehr, da jeder Prozess unabhängig von den anderen läuft und der Code dadurch übersichtlich und sicher bleibt.

Auch der Pipe-Operator hat mich überzeugt. Ähnlich wie Java Streams ermöglicht er es, Folgeoperationen sauber und lesbar darzustellen.

Was mich weniger überzeugt hat, ist die Möglichkeit verschiedene Typen direkt miteinander zu vergleichen. Es ist mir nicht ganz klar wo man das sinnvoll einsetzen würde, trotzdem muss man es kennen um fremden Code verstehen zu können.

Insgesamt finde ich Elixir eine ansprechende Sprache. Ein abschliessendes Fazit ist jedoch schwierig zu ziehen, da wir hauptsächlich kurze, unabhängige Scripts programmiert haben. Wie sich die Sprache in einem grösseren Projekt anfühlt, bleibt offen.


---

## 6. Quellen

- Elixir Official Documentation: https://elixir-lang.org/docs.html
- Elixir School: https://elixirschool.com
- Discord Engineering Blog: https://elixir-lang.org/blog/2020/10/08/real-time-communication-at-scale-with-elixir-at-discord/
