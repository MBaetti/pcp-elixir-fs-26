# Dokumentation

## Kernpunkte

**Vorgeschlagen**

- The Actor Model
- Abgrenzung von Erlang
- Enumerables and Streams (lazy & async)
- Comprehensions and into-option
- Macros and Quotes
- Pattern Matching

**Zusätzlich**

- Pipe-Operator
- "Let it crash" & Supervisor Trees

**Ausgewählt**

- Concurrency: The Actor Model
- Comprehensions
- Metaprogramming: Macros and Quotes
- OPT Supervisors

### Concurrency: The Actor Model

*Berarbeitet von:* Mathias

Nebenläufigkeit wird durch isolierte Prozesse umgesetzt. Diese teilen sich keinen Arbeitsspeicher, sondern kommunizieren ausschliesslich über den asynchronen Austausch von Nachrichten.

[*Quellcode*](lib/concurrency.exs)

[Elexirscool](https://elixirschool.com/de/lessons/intermediate/concurrency)

### Comprehensions

*Berarbeitet von:* Mathias

Ein Konstrukt zur kompakten Iteration, Filterung und Transformation von Aufzählungen. Das Ergebnis der Transformation wird dabei direkt in eine definierte Zieldatenstruktur überführt.

[*Quellcode*](lib/comprehensions.exs)

[Elexirscool](https://elixirschool.com/de/lessons/basics/comprehensions)

### Metaprogramming: Macros and Quotes

*Berarbeitet von:* Maurice

Mechanismen der Metaprogrammierung. Quellcode wird in seinen abstrakten Syntaxbaum umgewandelt und kann so zur Kompilierzeit programmatisch modifiziert oder zur Spracherweiterung genutzt werden.

[*Quellcode*](lib/metaprogramming.exs)

[Elexirscool](https://elixirschool.com/de/lessons/advanced/metaprogramming)

### OPT Supervisors

*Berarbeitet von:* Maurice

Ein Konzept zur Fehlerbehandlung, bei dem fehlerhafte Prozesse umgehend beendet werden. Übergeordnete Überwachungsprozesse registrieren den Ausfall und starten den betroffenen Prozess automatisch in einem definierten Ausgangszustand neu.

[*Quellcode*](lib/supervisors.exs)

[Elexirscool](https://elixirschool.com/de/lessons/advanced/otp_supervisors)

## Reihenfolge Präsentation

1. Interesting Facts
2. Comprehensions
3. Concurrency: The Actor Model
4. Supervisors
5. Metaprogramming: Macros and Quotes
