defmodule TwoD.Helpers do
  @deg_to_rad :math.pi / 180.0

  def rotate({x, y}, angle) do
    radians = angle * @deg_to_rad
    { x * :math.cos(radians) - y * :math.sin(radians),
      x * :math.sin(radians) + y * :math.cos(radians) }
  end

  def round_point({x, y}), do: [round(x), round(y)]

  def prepare_observed_vector(vector, angle, axis) do
    rotate(vector, angle) |> round_point |> Enum.zip([axis, axis])
  end

  defmacro def_optimized_rotate(angle) do
    result = quote(bind_quoted: [angle_copy: angle], unquote: false) do
      # We are using the two unit vectors to observe how they are affected by a
      # rotation
      rot_x = TwoD.Helpers.prepare_observed_vector {1, 0}, angle_copy, :x
      rot_y = TwoD.Helpers.prepare_observed_vector {0, 1}, angle_copy, :y

      # Now map each of these to a quoted expression
      [xx, xy, yx, yy] =
        (rot_x ++ rot_y)
        |> Enum.map(fn
            {-1, axis} ->
              quote do: (-unquote(Macro.var(axis, __MODULE__)))
            {0, _} ->
              nil
            {1, axis} ->
              Macro.var(axis, __MODULE__)
          end)

      quoted_code_for_x = (xx || yx)
      quoted_code_for_y = (xy || yy)
      quoted_xy = for v <- [:x, :y], do: Macro.var(v, __MODULE__)

      def rotate({unquote_splicing(quoted_xy)}, unquote(angle_copy)) do
        {unquote(quoted_code_for_x), unquote(quoted_code_for_y)}
      end
    end


    # IO.puts "== resulting code"
    # IO.puts Macro.to_string(result)
    result
  end
end

defmodule TwoD do
  require TwoD.Helpers
  @angles for n <- -4..4, do: 90.0 * n

  # Optimized versions of the code
  for angle <- @angles, do: TwoD.Helpers.def_optimized_rotate(angle)
  
  # This general purpose implementation will serve any other angle
  def rotate(point, angle), do: TwoD.Helpers.rotate(point, angle)
end

