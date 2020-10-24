const JUMP_POWER := 160.0
const JUMP_UP_MULTIPLIER := 0.8 # Должно быть меньше 1.
var current_jump_power := JUMP_POWER

const GRAVITY := 60.0
const JUMP_DOWN_MULTIPLIER := 1.01 # Должно быть больше 1.
var current_gravity := GRAVITY

const ROOF := 700

var is_jump_pressed := false


func jumping(y: float) -> float:
    y = 0
    current_gravity = GRAVITY

    if Input.is_action_just_pressed('ui_select'):
        is_jump_pressed = true
        y = -JUMP_POWER

    return y


func ceiling(y: float) -> float:
    Input.action_release('ui_select')

    is_jump_pressed = false
    y = GRAVITY

    return y


func continuous_jumping(y: float) -> float:
    if is_jump_pressed and Input.is_action_pressed('ui_select') and y > -ROOF:
        current_jump_power *= JUMP_UP_MULTIPLIER
        y -= current_jump_power

        if y < -ROOF:
            y = -ROOF

    else:
        is_jump_pressed = false

        current_gravity *= JUMP_DOWN_MULTIPLIER
        y += current_gravity

    if Input.is_action_just_released('ui_select'):
        is_jump_pressed = false
        current_jump_power = JUMP_POWER

    return y
