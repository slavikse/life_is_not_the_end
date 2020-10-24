const SPEED := 80
const INITIAL_SPEED := SPEED / 2
const MAX_SPEED := SPEED * 8
const SPEED_DECREASE := SPEED * 1.5

var is_left_pressed := false
var is_right_pressed := false


func moving(x: float) -> float:
    move_controls()

    if is_left_pressed and is_right_pressed:
        x = fast_deceleration(x)

    else:
        x = move_left(x)
        x = move_right(x)

    return x


func move_controls() -> void:
    if Input.is_action_just_pressed('ui_left'):
        is_left_pressed = true

    if Input.is_action_just_released('ui_left'):
        is_left_pressed = false

    if Input.is_action_just_pressed('ui_right'):
        is_right_pressed = true

    if Input.is_action_just_released('ui_right'):
        is_right_pressed = false


func fast_deceleration(x: float) -> float:
    x -= SPEED_DECREASE

    if x < 0:
        x = 0

    return x


func move_left(x: float) -> float:
    if is_left_pressed:
        if x == 0:
            x = -INITIAL_SPEED

        elif x > 0:
            x = 0

        else:
            x -= SPEED

            if x < -MAX_SPEED:
                x = -MAX_SPEED

    elif x < 0:
        x += SPEED_DECREASE

        if x > 0:
            x = 0

    return x


func move_right(x: float) -> float:
    if is_right_pressed:
        if x == 0:
            x = INITIAL_SPEED

        elif x < 0:
            x = 0

        else:
            x += SPEED

            if x > MAX_SPEED:
                x = MAX_SPEED

    elif x > 0:
        x -= SPEED_DECREASE

        if x < 0:
            x = 0

    return x
