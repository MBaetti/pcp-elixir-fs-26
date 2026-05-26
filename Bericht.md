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
## 2. Interessant anderst

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

### 3.4 Metaprogramming – Macros & Quotes

---

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

...

### Mathias Vogel

...

---

## 6. Quellen

- Elixir Official Documentation: https://elixir-lang.org/docs.html
- Elixir School: https://elixirschool.com
- Discord Engineering Blog: https://elixir-lang.org/blog/2020/10/08/real-time-communication-at-scale-with-elixir-at-discord/
