# Comprehensions
# Skript ausführen: elixir comprehensions.exs
# Interaktive Shell starten: iex.bat -S mix

# Liste mit Namen
names = ["Joe", "Tara", "Sue", "Tim"]

# Mit Comprehensions
listResult = for name <- names,
             String.starts_with?(name, "T"),
             do: String.upcase(name)

stringResult = Enum.join(listResult, " ")
IO.puts(stringResult)


# Mit dem Pipe-Operator (& definiert eine anonyme Funktion)
stringResult2 = names
                |> Enum.filter(&String.starts_with?(&1, "T"))
                |> Enum.map(&String.upcase/1)
                |> Enum.join(" ")

IO.puts(stringResult2)
