# Metaprogrammierung in Elixir
# Skript ausführen: elixir metaprogramming.exs
# Interaktive Shell starten: iex.bat -S mix
# File in die Shell laden: import_file("./lib/metaprogramming.exs")

# - Quote -
# quote gibt abstract syntax tree zurück, also die Struktur des Codes, ohne ihn auszuführen
# Das zurückgegebene Tuple besteht aus:
# {
#  Operator,
#  Metadaten,
#  Funktionsargumente
# }

value1 = 2

quote do: 1 + value1

# - Unquote -
# unquote ermöglicht es, Werte in einen quote-Ausdruck einzufügen, damit sie zur Kompilierzeit ausgewertet werden können

value2 = 2

quote do: 1 + unquote(value2)

# - Makros -
# Für:
# - Spracherweiterungen
# - Entwicklung von DSLs (Domain Specific Languages)
# - Compile-Zeit-Optimierungen
# - Lazy Evaluation wie im Beispiel -> do wird nur ausgewertet, wenn die Bedingung erfüllt ist

defmodule MyMacro do
  defmacro ifTrue(expr, do: sehrAufwaendig) do
    quote do
      if unquote(expr), do: unquote(sehrAufwaendig)
    end
  end
end

require MyMacro

MyMacro.ifTrue(true, do: "Hi")
MyMacro.ifTrue(false, do: "Hi")

# Die if-Abfrage ist ebenfalls als Makro umgesetzt
# Mit Macro.expand den erzeugten Code dazu anzeigen lassen
# quote(do: if(true, do: "Hi")) |> Macro.expand(__ENV__) |> Macro.to_string() |> IO.puts()

###################################################################################################

# - Hygiene -
# Hygienische Variablen kolidieren nicht mit Variablen im Kontext, in dem das Makro aufgerufen wird.
defmodule Hygene do
  defmacro hygienic do
    quote do: value3 = 0
  end

  defmacro unhygienic do
    quote do: var!(value3) = -1
  end
end

require Hygene

# value3 = 42
# Hygene.hygienic()
# Hygene.unhygienic()
# value3

# - Bindung -
# Das Beispiel liefert unterschiedliche Zeiten, da der Ausdruck zweimal ausgewertet wird
defmodule Example do
  defmacro double_puts(expr) do
    quote do
      IO.puts(unquote(expr))
      IO.puts(unquote(expr))
    end
  end
end

# Um ihn an eine Auswertung zu binden kann bind_quoted verwendet werden
defmodule Example2 do
  defmacro double_puts(expr) do
    quote bind_quoted: [expr: expr] do
      IO.puts(expr)
      IO.puts(expr)
    end
  end
end

# - Ende -
IO.puts("Metaprogramming erfolgreich geladen.")
