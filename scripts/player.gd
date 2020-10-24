extends KinematicBody2D

const MOVE_SPEED := 80
const FIRST_MOVE_SPEED := MOVE_SPEED / 2
const MOVE_SPEED_DECREASE := MOVE_SPEED * 1.5
const MAX_MOVE_SPEED := 600

const JUMP_POWER := 110
const GRAVITY := 80
const GRAVITY_FREE_FALL := GRAVITY * 0.8

const ROOF := 800
const FLOOR := Vector2.UP

var velocity := Vector2.ZERO;
var is_move_left_pressed := false
var is_move_right_pressed := false
var is_jump_pressed := false

onready var sprite := $Sprite as Sprite


#warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
    moving()
    jumping()
    sprite_flip()

    #warning-ignore:return_value_discarded
    move_and_slide(velocity, FLOOR)


func moving() -> void:
    move_controls()

    if is_move_left_pressed and is_move_right_pressed:
        velocity.x -= MOVE_SPEED_DECREASE

        if velocity.x < 0:
            velocity.x = 0

    else:
        move_left()
        move_right()

    if is_on_wall():
        velocity.x = 0


func move_controls():
    if Input.is_action_just_pressed('ui_left'):
        is_move_left_pressed = true

    if Input.is_action_just_released('ui_left'):
        is_move_left_pressed = false

    if Input.is_action_just_pressed('ui_right'):
        is_move_right_pressed = true

    if Input.is_action_just_released('ui_right'):
        is_move_right_pressed = false


func move_left():
    if is_move_left_pressed:
        if velocity.x == 0:
            velocity.x = -FIRST_MOVE_SPEED

        elif velocity.x > 0:
            velocity.x = 0

        else:
            velocity.x -= MOVE_SPEED

            if velocity.x < -MAX_MOVE_SPEED:
                velocity.x = -MAX_MOVE_SPEED

    elif velocity.x < 0:
        velocity.x += MOVE_SPEED_DECREASE

        if velocity.x > 0:
            velocity.x = 0


func move_right():
    if is_move_right_pressed:
        if velocity.x == 0:
            velocity.x = FIRST_MOVE_SPEED

        elif velocity.x < 0:
            velocity.x = 0

        else:
            velocity.x += MOVE_SPEED

            if velocity.x > MAX_MOVE_SPEED:
                velocity.x = MAX_MOVE_SPEED

    elif velocity.x > 0:
        velocity.x -= MOVE_SPEED_DECREASE

        if velocity.x < 0:
            velocity.x = 0


func jumping() -> void:
    if is_on_floor():
        velocity.y = 0

        if Input.is_action_just_pressed('ui_select'):
            is_jump_pressed = true
            velocity.y = -JUMP_POWER

    continuous_jump()

    if Input.is_action_just_released('ui_select'):
        is_jump_pressed = false


func continuous_jump() -> void:
    if is_on_ceiling():
        Input.action_release('ui_select')
        is_jump_pressed = false
        velocity.y = GRAVITY_FREE_FALL

    elif is_jump_pressed and Input.is_action_pressed('ui_select') and velocity.y > -ROOF:
        velocity.y -= JUMP_POWER

        if velocity.y < -ROOF:
            velocity.y = -ROOF

    else:
        is_jump_pressed = false
        velocity.y += GRAVITY_FREE_FALL


func sprite_flip() -> void:
    if velocity.x != 0:
        sprite.flip_h = velocity.x < 0
