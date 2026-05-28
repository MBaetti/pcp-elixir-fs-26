# Concurrency: The Actor Model
# Skript ausführen: elixir ./lib/concurrency.exs
# Interaktive Shell starten: iex.bat
# File in die Shell laden: import_file("./lib/concurrency.exs")

defmodule Demo do
  def run do
    main = self()

    # Task 3
    pid3 =
      spawn(fn ->
        receive do
          {:step3, val} ->
            :timer.sleep(3000)
            IO.write(val)
            send(main, :done)
        end
      end)

    # Task 2 braucht pid3
    pid2 =
      spawn(fn ->
        receive do
          {:step2, val} ->
            :timer.sleep(3000)
            IO.write("2")
            send(pid3, {:step3, "The answer is #{val}"})
        end
      end)

    # Task 1 braucht pid2
    spawn(fn ->
      :timer.sleep(3000)
      IO.write("1")
      send(pid2, {:step2, "42"})
    end)

    IO.puts("-> Now waiting for things to happen!")

    for _ <- 1..20,
        do:
          (
            IO.write(".")
            :timer.sleep(500)
          )

    receive do: (:done -> IO.puts("\n-> Done."))
  end
end

Demo.run()
