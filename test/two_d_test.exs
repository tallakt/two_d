defmodule TwoD.Tests do
  use ExUnit.Case, async: true
  alias TwoD.Helpers, as: H

  @point {123.0, 456.0}

  def round_point({x, y}), do: {round(x), round(y)}
  
  test "optimized rotates must match generic version" do
    assert (TwoD.rotate(@point, -270.0) |> round_point) == 
      (H.rotate(@point, -270.0) |> round_point)

    assert (TwoD.rotate(@point, 0.0) |> round_point) == 
      (H.rotate(@point, 0.0) |> round_point)

    assert (TwoD.rotate(@point, 90.0) |> round_point) == 
      (H.rotate(@point, 90.0) |> round_point)
  end

  test "the non right/straight angles should still work" do
    assert (TwoD.rotate(@point, 85.0) |> round_point) == 
      (H.rotate(@point, 85.0) |> round_point)
  end
end

