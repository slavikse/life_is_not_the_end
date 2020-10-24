var is_little := false
var small := Vector2(0.6, 0.6)
var normal := Vector2(1.0, 1.0)
var interpolation_time := 0.1


# TDOO если увиличиться в месте, где персонаж не влезет - то это его уничтожит / fn.
func transform(scale: Vector2) -> Vector2:
    if Input.is_action_just_pressed('ui_shape'):
        is_little = !is_little

    var target_scale := small if is_little else normal

    return scale.linear_interpolate(target_scale, interpolation_time)
