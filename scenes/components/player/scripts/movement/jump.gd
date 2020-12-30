const N_JUMP_POWER := 90.0
const N_JUMP_UP_MULTIPLIER := 0.95
const N_JUMP_DOWN_MULTIPLIER := 1.01
const N_ROOF := 900.0

const S_JUMP_POWER := 92.5
const S_JUMP_UP_MULTIPLIER := 0.97
const S_JUMP_DOWN_MULTIPLIER := 1.005
const S_ROOF := 1030.0

# При изменении, обновить VERTICAL_VELOCITY_DEFAULT.
const GRAVITY := 25.0

# JUMP_UP_MULTIPLIER - Должно быть меньше или равно 1.0
# JUMP_DOWN_MULTIPLIER - Должно быть больше или равно 1.0

# N - Normal Shape | S - Small Shape

# Начальное состояние Normal Shape (N_): shape.gd -> is_normal_shape := true
var current_gravity := GRAVITY
var current_jump_power := N_JUMP_POWER

var is_jump_pressed := false


func jumping(y: float, is_normal_shape: bool) -> float:
    current_gravity = GRAVITY if is_normal_shape else GRAVITY
    current_jump_power = N_JUMP_POWER if is_normal_shape else S_JUMP_POWER

    if Input.is_action_just_pressed('player_jump'):
        is_jump_pressed = true
        y = -N_JUMP_POWER if is_normal_shape else -S_JUMP_POWER

    return y


func ceiling(y: float, is_normal_shape: bool) -> float:
    is_jump_pressed = false
    y = GRAVITY if is_normal_shape else GRAVITY

    return y


func continuous_jumping(y: float, is_normal_shape: bool) -> float:
    if Input.is_action_just_released('player_jump'):
        is_jump_pressed = false

    if is_jump_pressed:
        current_jump_power *= N_JUMP_UP_MULTIPLIER if is_normal_shape else S_JUMP_UP_MULTIPLIER
        y -= current_jump_power

        var roof := N_ROOF if is_normal_shape else S_ROOF

        if y < -roof:
            y = -roof
            is_jump_pressed = false

    else:
        current_gravity *= N_JUMP_DOWN_MULTIPLIER if is_normal_shape else S_JUMP_DOWN_MULTIPLIER
        y += current_gravity

    return y
