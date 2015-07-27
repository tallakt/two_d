defmodule TwoD.Tests do
  use ExUnit.Case, async: true
  
  def test_generic_vs_optimized(angle) do
    point = {123.0, 456.0}
    {x1, y1} = TwoD.rotate(point, -270.0) 
    {x2, y2} = TwoD.Helpers.rotate(point, -270.0) 
    assert_in_delta x1, x2, 0.01
    assert_in_delta y1, y2, 0.01
  end

  test "optimized rotates must match generic version" do
    test_generic_vs_optimized -270.0
    test_generic_vs_optimized 0.0
    test_generic_vs_optimized 90.0
  end
end

