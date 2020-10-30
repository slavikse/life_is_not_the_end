extends KinematicBody2D

class_name Player

var shape := preload('./shape.gd').new()
var move := preload('./move.gd').new()
var jump := preload('./jump.gd').new()

const FLOOR := Vector2.UP
var velocity := Vector2.ZERO;

var is_can_zoom_out := true
var is_stumbled := false

onready var sprite_node := $Sprite as Sprite


#warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
    if is_stumbled:
        return

    if is_can_zoom_out:
        scale = shape.transform(scale)

    moving()
    jumping()
    sprite_flip()

    velocity = move_and_slide(velocity, FLOOR)


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
        sprite_node.flip_h = velocity.x < 0


func _on_IsCanZoomOut_is_can_zoom_out(flag: bool) -> void:
    is_can_zoom_out = flag


func _on_Spike_stumbled() -> void:
    is_stumbled = true
    visible = false


# TODO восстановить управление и переместить в новую позицию. удалить мертвеца
# TODO анимация поднятия
func risen(dead_position: Vector2) -> void:
    position = dead_position
    print('dead_position', dead_position)

    is_stumbled = false
    visible = true
