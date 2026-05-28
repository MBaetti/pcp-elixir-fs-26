# Typen vergleichen
# Skript ausführen: elixir ./lib/interesting-features.exs
# Interaktive Shell starten: iex.bat
# File in die Shell laden: import_file("./lib/interesting-features.exs")

# number < atom < reference < function < port < pid < tuple < map < list < bitstring

result = 40 < "30"
IO.puts(result)
