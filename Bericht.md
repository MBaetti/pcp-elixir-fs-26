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
## 2. Interessante Konzepte

---

## 3. Fokuspunkte

### 3.1 Comprehensions & Pipe-Operator

### 3.2 Concurrency – The Actor Model

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
