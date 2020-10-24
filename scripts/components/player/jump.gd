const JUMP_POWER := 110
const GRAVITY := 80 * 0.8
const ROOF := 800

var is_jump_pressed := false


func jumping(y: float) -> float:
    y = 0

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
        y -= JUMP_POWER

        if y < -ROOF:
            y = -ROOF

    else:
        is_jump_pressed = false
        y += GRAVITY

    if Input.is_action_just_released('ui_select'):
        is_jump_pressed = false

    return y
