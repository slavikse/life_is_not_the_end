extends KinematicBody2D

class_name Player

var move := preload('./move.gd').new()
var jump := preload('./jump.gd').new()
var shape := preload('./shape.gd').new()

const FLOOR := Vector2.UP
var velocity := Vector2.ZERO;

var is_stumbled := false
var is_can_zoom_out := true

onready var sprite_node := $Sprite as Sprite
onready var animation_node := $AnimationPlayer as AnimationPlayer


func _physics_process(_delta: float) -> void:
    if is_stumbled:
        return

    moving()
    jumping()
    sprite_flip()

    if is_can_zoom_out:
        shape.switch_scale(animation_node)

    velocity = move_and_slide(velocity, FLOOR)


# TODO звук шага вызывать через плеер анимации с помощью обратного вызова на ключевом кадре
# https://docs.godotengine.org/ru/stable/tutorials/animation/introduction_2d.html#advanced-call-method-tracks
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

    if not is_can_zoom_out and shape.is_normal_shape:
        scale = shape.force_to_small_scale(animation_node)


# TODO в месте соприкосновения вставить спрайт удара, чтобы игрок понимал, что произошло
func _on_Spike_stumbled() -> void:
    visible = false
    is_stumbled = true


# TODO восстановить управление и переместить в новую позицию
# TODO анимация поднятия
# TODO удалить мертвеца
func external_risen(dead_position: Vector2) -> void:
    position = dead_position

    is_stumbled = false
    visible = true
