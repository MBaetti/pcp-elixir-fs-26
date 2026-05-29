# Comprehensions
# Skript ausführen: elixir ./lib/comprehensions.exs
# Interaktive Shell starten: iex.bat
# File in die Shell laden: import_file("./lib/comprehensions.exs")

# Beispiele anhand des Demo-Codes SW09 Java: Lambda-Beispiel

# Liste mit Namen
names = ["Joe", "Tara", "Sue", "Tim"]

# Mit Comprehensions
listResult =
  for name <- names,
      String.starts_with?(name, "T"),
      do: String.upcase(name)

stringResult = Enum.join(listResult, " ")
IO.puts(stringResult)

# Mit dem Pipe-Operator (& definiert eine anonyme Funktion)
stringResult2 =
  names
  |> Enum.filter(&String.starts_with?(&1, "T"))
  |> Enum.map(&String.upcase/1)
  |> Enum.join(" ")

IO.puts(stringResult2)

# Mit Comprehensions und dem into-Option
stringResult3 =
  for name <- names,
      String.starts_with?(name, "T"),
      into: "",
      do: String.upcase(name) <> " "

IO.puts(String.trim(stringResult3))

# Mit Comprehensions und dem into-Option, um ein MapSet zu erstellen
numbers = [1, 2, 2, 3, 3]

numberResult = for x <- numbers, into: MapSet.new(), do: x
IO.inspect(numberResult)

for x <- numberResult do
  IO.puts(x)
end
