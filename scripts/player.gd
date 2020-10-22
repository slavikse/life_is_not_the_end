extends KinematicBody2D

const FIRST_MOVE_SPEED := 40
const MOVE_SPEED := 80
const MOVE_SPEED_DECREASE := MOVE_SPEED * 1.5
const MAX_MOVE_SPEED := 500

const FIRST_JUMP_POWER := 160
const JUMP_POWER := 80

const GRAVITY := 80
const GRAVITY_FREE_FALL := GRAVITY * 0.8

const ROOF := 700
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
    if Input.is_action_just_pressed('ui_left'):
        is_move_left_pressed = true

    if Input.is_action_just_released('ui_left'):
        is_move_left_pressed = false

    if Input.is_action_just_pressed('ui_right'):
        is_move_right_pressed = true

    if Input.is_action_just_released('ui_right'):
        is_move_right_pressed = false

    if is_move_left_pressed and is_move_right_pressed:
        velocity.x -= MOVE_SPEED_DECREASE

        if velocity.x < 0:
            velocity.x = 0
    else:
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

    if is_on_wall():
        velocity.x = 0


# TODO отскоки от стен: is_on_wall
func jumping() -> void:
    first_jump()
    stretched_jump()

    if Input.is_action_just_released('ui_select'):
        is_jump_pressed = false


# TODO иногда бывает что не срабатывает прыжок. может нужно триггерить метод "на земле", когда к ней приблизился достаточно близко
#   сделать невидимую "нажимную" плиту над блоком, при пересечении с которой, будет считать, что игрок на полу.
func first_jump() -> void:
    # TODO заменить на собственное событие от блока, на который наступил персонаж.
    if is_on_floor():
        velocity.y = 0

        if Input.is_action_just_pressed('ui_select'):
            is_jump_pressed = true
            velocity.y = -FIRST_JUMP_POWER


func stretched_jump() -> void:
    if is_jump_pressed and Input.is_action_pressed('ui_select') and velocity.y > -ROOF:
        # TODO при прыжке не много зависает на потолке, когда есть ускорение вверх.
        #   заменить механику на схожую, какая будет при прыжках
        if is_on_ceiling():
            Input.action_release('ui_select')
            is_jump_pressed = false
            velocity.y = GRAVITY_FREE_FALL
        else:
            velocity.y -= JUMP_POWER

            if velocity.y < -ROOF:
                velocity.y = -ROOF
    else:
        is_jump_pressed = false
        velocity.y += GRAVITY_FREE_FALL


func sprite_flip() -> void:
    if velocity.x != 0:
        sprite.flip_h = velocity.x < 0
