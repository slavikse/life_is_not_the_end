extends KinematicBody2D

var shape := preload('./shape.gd').new()
var move := preload('./move.gd').new()
var jump := preload('./jump.gd').new()

const FLOOR := Vector2.UP
var velocity := Vector2.ZERO;

onready var sprite := $Sprite as Sprite


#warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
    scale = shape.transform(scale)

    moving()
    jumping()
    sprite_flip()

    velocity = move_and_slide(velocity, FLOOR)


# TDOO если увиличиться в месте, где персонаж не влезет - то это его уничтожит / fn.
#   на таком месте будут иголки, которые прикончат персонажа.
func moving() -> void:
    velocity.x = move.moving(velocity.x, shape.is_normal_shape)

    if is_on_wall():
        velocity.x = 0


func jumping() -> void:
    if is_on_floor():
        velocity.y = jump.jumping(velocity.y, shape.is_normal_shape)

    if is_on_ceiling():
        velocity.y = jump.ceiling(velocity.y, shape.is_normal_shape)

    velocity.y = jump.continuous_jumping(velocity.y, shape.is_normal_shape)


# TODO advance(0) - для быстрой смены стороны в анимации при развороте
func sprite_flip() -> void:
    if velocity.x != 0:
        sprite.flip_h = velocity.x < 0
