# N - Normal Shape
# S - Small Shape

# JUMP_UP_MULTIPLIER - Должно быть меньше или равно 1.0
# JUMP_DOWN_MULTIPLIER - Должно быть больше или равно 1.0

const N_JUMP_POWER := 180.0
const N_JUMP_UP_MULTIPLIER := 0.8
const N_GRAVITY := 60.0
const N_JUMP_DOWN_MULTIPLIER := 1.02
const N_ROOF := 770.0

const S_JUMP_POWER := 200.0
const S_JUMP_UP_MULTIPLIER := 0.9
const S_GRAVITY := 60.0
const S_JUMP_DOWN_MULTIPLIER := 1.0
const S_ROOF := 1050.0

# Начальное состояние Normal Shape (N_): shape.gd -> is_normal_shape := true
var current_gravity := N_GRAVITY
var current_jump_power := N_JUMP_POWER

var is_jump_pressed := false


func jumping(y: float, is_normal_shape: bool) -> float:
    y = 0
    current_gravity = N_GRAVITY if is_normal_shape else S_GRAVITY

    if Input.is_action_just_pressed('ui_up'):
        is_jump_pressed = true
        y = -N_JUMP_POWER if is_normal_shape else -S_JUMP_POWER

    return y


func ceiling(y: float, is_normal_shape: bool) -> float:
    Input.action_release('ui_up')

    is_jump_pressed = false
    y = N_GRAVITY if is_normal_shape else S_GRAVITY

    return y


func continuous_jumping(y: float, is_normal_shape: bool) -> float:
    var roof := N_ROOF if is_normal_shape else S_ROOF

    if is_jump_pressed and Input.is_action_pressed('ui_up') and y > -roof:
        current_jump_power *= N_JUMP_UP_MULTIPLIER if is_normal_shape else S_JUMP_UP_MULTIPLIER
        y -= current_jump_power

        if y < -roof:
            y = -roof

    else:
        is_jump_pressed = false

        current_gravity *= N_JUMP_DOWN_MULTIPLIER if is_normal_shape else S_JUMP_DOWN_MULTIPLIER
        y += current_gravity

    if Input.is_action_just_released('ui_up'):
        is_jump_pressed = false
        current_jump_power = N_JUMP_POWER if is_normal_shape else S_JUMP_POWER

    return y
