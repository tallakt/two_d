defmodule TwoD.Helpers do
  @deg_to_rad 180.0 * :math.pi

  def rotate({x, y}, angle) do
    radians = angle * @deg_to_rad
    { x * :math.cos(radians) - y * :math.sin(radians),
      x * :math.sin(radians) + y * :math.cos(radians) }
  end

  defp round_point({x, y}), do: [round(x), round(y)]

  defmacro def_optimized_rotate(angle_quoted) do
    # angle is still code, so it must be evaluated to get a number
    {angle, _} = Code.eval_quoted angle_quoted

    # We are using the two unit vectors to observe how they are affected by a
    # rotation
    rot_x = rotate({1, 0}, angle) |> round_point |> Enum.zip([:x, :y])
    rot_y = rotate({0, 1}, angle) |> round_point |> Enum.zip([:x, :y])

    # Now map each of these to a quoted expression
    [xx, xy, yx, yy] =
      (rot_x ++ rot_y)
      |> Enum.map(fn
          {-1, name} ->
            quote do: -unquote(Macro.var(name, __MODULE__))
          {0, _} ->
            nil
          {1, name} ->
            Macro.var(name, __MODULE__)
        end)

    # at last return a quoted function definition
    quote do
      def rotate({x, y}, unquote(angle * 1.0)) do
        {unquote(xx || yx), unquote(xy || yy)}
      end
    end
  end
end

defmodule TwoD do
  require TwoD.Helpers

  # Optimized versions of the code
  TwoD.Helpers.def_optimized_rotate(-270)
  TwoD.Helpers.def_optimized_rotate(-180)
  TwoD.Helpers.def_optimized_rotate(-90)
  TwoD.Helpers.def_optimized_rotate(0)
  TwoD.Helpers.def_optimized_rotate(90)
  TwoD.Helpers.def_optimized_rotate(180)
  TwoD.Helpers.def_optimized_rotate(270)
  
  # This general purpose implementation will serve any other angle
  def rotate(point, angle), do: TwoD.Helpers.rotate(point, angle)
end
