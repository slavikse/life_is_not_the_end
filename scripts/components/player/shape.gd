var is_normal_shape := true
var small_scale := Vector2(0.6, 0.6)
# var normal_shape := Vector2(1.0, 1.0)


func switch_scale(animation_node: AnimationPlayer) -> void:
    if Input.is_action_just_pressed('ui_transform'):
        is_normal_shape = !is_normal_shape

        if is_normal_shape:
            animation_node.play('shape_increase')

        else:
            animation_node.play('shape_decrease')


func force_to_small_scale(animation_node: AnimationPlayer) -> Vector2:
    is_normal_shape = false
    animation_node.stop()

    return small_scale
