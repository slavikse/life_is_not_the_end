extends KinematicBody2D

const SPEED := 400
const FIRST_POWER_JUMP := 160
const POWER_JUMP := 90
const GRAVITY := 90
const ROOF := 800
const FLOOR := Vector2.UP

var velocity := Vector2.ZERO;
var is_jump_pressed := false

onready var sprite := $Sprite as Sprite


#warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
    moving()
    jumping()

    #warning-ignore:return_value_discarded
    move_and_slide(velocity, FLOOR)


func moving() -> void:
    velocity.x = 0

    if Input.is_action_pressed('ui_left'):
        velocity.x -= SPEED

    if Input.is_action_pressed('ui_right'):
        velocity.x += SPEED

    if velocity.x != 0:
        sprite.flip_h = velocity.x < 0


func jumping() -> void:
    if Input.is_action_just_released('ui_select'):
        is_jump_pressed = false

    if not is_jump_pressed and is_on_floor():
        velocity.y = 0

        if Input.is_action_just_pressed('ui_select'):
            is_jump_pressed = true
            velocity.y = -FIRST_POWER_JUMP

    if is_jump_pressed and velocity.y > -ROOF and Input.is_action_pressed('ui_select'):
        if is_on_ceiling():
            Input.action_release('ui_select')
            velocity.y = GRAVITY

        else:
            velocity.y -= POWER_JUMP

            if velocity.y < -ROOF:
                velocity.y = -ROOF

    elif velocity.y < ROOF:
        is_jump_pressed = false
        velocity.y += GRAVITY

        if velocity.y > ROOF:
            velocity.y = ROOF
