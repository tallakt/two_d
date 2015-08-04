defmodule TwoD.Helpers do
  @deg_to_rad :math.pi / 180.0

  def rotate({x, y}, angle) do
    radians = angle * @deg_to_rad
    { x * :math.cos(radians) - y * :math.sin(radians),
      x * :math.sin(radians) + y * :math.cos(radians) }
  end

  defmacro def_optimized_rotate(angle) do
    res=quote(bind_quoted: [angle_copy: angle], unquote: false) do
      x_quoted = Macro.var(:x, __MODULE__)
      y_quoted = Macro.var(:y, __MODULE__)
      neg_x_quoted = quote do: (-unquote(Macro.var(:x, __MODULE__)))
      neg_y_quoted = quote do: (-unquote(Macro.var(:y, __MODULE__)))

      # normalize to 0..360; must add 360 in case of negative angle values
      normalized = angle_copy |> round |> rem(360) |> Kernel.+(360) |> rem(360)

      result_vars_quoted = case normalized do
        0 -> 
          [x_quoted, y_quoted]
        90 ->
          [neg_y_quoted, x_quoted]
        180 ->
          [neg_x_quoted, neg_y_quoted]
        270 ->
          [y_quoted, neg_x_quoted]
        _ ->
          raise "Optimized angles must be right or straight"
      end 

      def rotate({unquote_splicing([x_quoted, y_quoted])}, unquote(1.0 * angle_copy)) do
        {unquote_splicing(result_vars_quoted)}
      end
    end
    res |> Macro.to_string |> IO.puts
    res
  end
end

defmodule TwoD do
  require TwoD.Helpers
  @angles for n <- -360..360, rem(n, 90) == 0, do: n

  # Optimized versions of the code
  for angle <- @angles, do: TwoD.Helpers.def_optimized_rotate(angle)
  
  # This general purpose implementation will serve any other angle
  def rotate(point, angle), do: TwoD.Helpers.rotate(point, angle)
end
