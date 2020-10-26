var is_normal_shape := true
var small_shape := Vector2(0.6, 0.6)
var normal_shape := Vector2(1.0, 1.0)
var interpolation_time := 0.5


func transform(scale: Vector2) -> Vector2:
    if Input.is_action_just_pressed('ui_transform'):
        is_normal_shape = !is_normal_shape

    var target_shape := normal_shape if is_normal_shape else small_shape

    return scale.linear_interpolate(target_shape, interpolation_time)
