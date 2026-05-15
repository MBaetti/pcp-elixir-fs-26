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

quote do: 1 + 2
# {
#  :+,
#  [context: Elixir, imports: [{1, Kernel}, {2, Kernel}]],
#  [1, 2]
# }

# - Unquote -
# unquote ermöglicht es, Werte in einen quote-Ausdruck einzufügen, damit sie zur Kompilierzeit ausgewertet werden können

value = 2

quote do: 1 + value
# {
#  :+,
#  [context: Elixir, imports: [{1, Kernel}, {2, Kernel}]],
#  [1, {:value, [], Elixir}]
# }

quote do: 1 + unquote(value)
# {
#  :+,
#  [context: Elixir, imports: [{1, Kernel}, {2, Kernel}]],
#  [1, 2]
# }
# 2 wird in den quote-Ausdruck eingefügt und zur Kompilierzeit ausgewertet

# -- Makros --
defmodule OurMacro do
  defmacro unless(expr, do: block) do
    quote do
      if !unquote(expr), do: unquote(block)
    end
  end
end

require OurMacro

OurMacro.unless(true, do: "Hi")
OurMacro.unless(false, do: "Hi")

# - Ende -
IO.puts("Metaprogramming erfolgreich geladen.")
