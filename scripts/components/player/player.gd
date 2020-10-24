extends KinematicBody2D

const FLOOR := Vector2.UP
var velocity := Vector2.ZERO;

var move := preload('./move.gd').new()
var jump := preload('./jump.gd').new()

onready var sprite := $Sprite as Sprite

# TODO Уменьшение / увеличение персонажа для прохождения уровней в разных местах (интерполяция)

#warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
    moving()
    jumping()

    sprite_flip()

#    if Input.is_action_just_pressed('ui_shape'):
#        print(1)

    #warning-ignore:return_value_discarded
    move_and_slide(velocity, FLOOR)


func moving() -> void:
    velocity.x = move.moving(velocity.x)

    if is_on_wall():
        velocity.x = 0


func jumping() -> void:
    if is_on_floor():
        velocity.y = jump.jumping(velocity.y)

    if is_on_ceiling():
        velocity.y = jump.ceiling(velocity.y)

    velocity.y = jump.continuous_jumping(velocity.y)


func sprite_flip() -> void:
    if velocity.x != 0:
        sprite.flip_h = velocity.x < 0
