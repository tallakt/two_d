defmodule TwoD.Tests do
  use ExUnit.Case, async: true
  alias TwoD.Helpers, as: H

  @point {123.0, 456.0}
  
  test "optimized rotates must match generic version" do
    assert (TwoD.rotate(@point, -270.0) |> H.round_point) == 
      (H.rotate(@point, -270.0) |> H.round_point)

    assert (TwoD.rotate(@point, 0.0) |> H.round_point) == 
      (H.rotate(@point, 0.0) |> H.round_point)

    assert (TwoD.rotate(@point, 90.0) |> H.round_point) == 
      (H.rotate(@point, 90.0) |> H.round_point)
  end

  test "the non right/straight angles should still work" do
    assert (TwoD.rotate(@point, 85.0) |> H.round_point) == 
      (H.rotate(@point, 85.0) |> H.round_point)
  end
end

