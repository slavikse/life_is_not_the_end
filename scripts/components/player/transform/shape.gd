const NORMAL_SHAPE := Vector2(1.0, 1.0)
const SMALL_SHAPE := Vector2(0.5, 0.5)

var is_normal_shape := true


func switch_scale(animation_scale_node: AnimationPlayer) -> void:
    if Input.is_action_just_pressed('ui_transform'):
        is_normal_shape = !is_normal_shape

        if is_normal_shape:
            animation_scale_node.play('shape_increase')

        else:
            animation_scale_node.play('shape_decrease')


func force_to_small_shape(animation_scale_node: AnimationPlayer) -> Vector2:
    is_normal_shape = false
    animation_scale_node.play('shape_decrease')

    return SMALL_SHAPE
