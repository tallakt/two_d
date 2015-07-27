defmodule Mix.Tasks.Benchmark do
  use Mix.Task

  def run(_) do
    IO.puts "Checking optimized vs unoptimized"
    Benchwarmer.benchmark(
      [&TwoD.Helpers.rotate/2, &TwoD.rotate/2], [{123.0, 456.0}, 180.0]
    )

    IO.puts "Checking overhead of having optimizations"
    Benchwarmer.benchmark(
      [&TwoD.Helpers.rotate/2, &TwoD.rotate/2], [{123.0, 456.0}, 182.0]
    )
  end
end
