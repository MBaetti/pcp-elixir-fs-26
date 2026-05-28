# Beispiel für eine Elixir-Quelldatei
# Applikation starten: iex.bat -S mix
# Hello hello() im Modul Compile aufrufen: Compile.hello()

defmodule Compile do
  @moduledoc """
  Documentation for `Compile`.
  """

  @doc """
  Hello world.

  ## Examples
      iex> Compile.hello()
  """
  def hello() do
    :world
  end
end
