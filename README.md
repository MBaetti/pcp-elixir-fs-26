# PCP Elixir Gruppenprojekt

Gruppenprojekt zur Programmiersprache Elixir im Modul PCP im Frühlingssemester 2026

*Teammitglieder:*
- [Maurice Bättig](https://github.com/MBaetti)
- [Mathias Vogel](https://github.com/MathiasVogel)

## Installation

Anleitung zur Installation der benötigten Software und Abhängigkeiten.

[Erlang und Elixir installieren](https://elixir-lang.org/install.html)

[Plugin in VS Code installieren](https://marketplace.visualstudio.com/items?itemName=JakeBecker.elixir-ls)

Danach die Version von Elixir und Erlang überprüfen:

```bash
elixir --version
erl -version
```

## Interaktive Shell starten

```bash
iex.bat -S mix
```

## Hilfe

```elixir
h()
```

## Projekt erstellen

```bash
mix new . --app pcp_elixir_source_code
```

## Elixir Projektstruktur

*_build:* Kompilierter Code (Build-Artefakte).

*.elixir_ls:* Cache für den Code-Editor (Language Server).

*lib:* Eigentlicher Quellcode.

*test:* Automatisierte Tests.

*.formatter.exs:* Regeln für den Code-Formatter.

*mix.exs:* Projektkonfiguration und externe Abhängigkeiten.

## Abhängigkeiten definieren

In der `mix.exs`-Datei die benötigten Abhängigkeiten hinzufügen. Zum Beispiel:

```elixir
def deps do
  [
    {:phoenix, "~> 1.1 or ~> 1.2"},
    {:phoenix_html, "~> 2.3"},
    {:cowboy, "~> 1.0", only: [:dev, :test]},
    {:slime, "~> 0.14"}
  ]
end
```

## Abhängigkeiten installieren

```bash
mix deps.get
```

## Projekt kompilieren

```bash
mix compile
```

Danach befindet sich die kompilierte Version des Projekts im Ordner `_build`.

## Dokumentation

[Dokumentation](doc.md) des Repositories.

## Nützliche Ressourcen

[Elixir Scool](https://elixirschool.com/de/)

[Fireship: Elixir in 100 Seconds](https://www.youtube.com/watch?v=R7t7zca8SyM)