extends KinematicBody2D

class_name Player

var move := preload('./movement/move.gd').new()
var jump := preload('./movement/jump.gd').new()
var shape := preload('./transform/shape.gd').new()
var animations := preload('./transform/animations.gd').new()

const FLOOR := Vector2.UP
const OFFSET_NORMAL_SHAPE := 4 * 8
const OFFSET_SMALL_SHAPE := 2 * 8

var velocity := Vector2.ZERO;
var is_can_zoom_out := true

onready var weapon_node := $Weapon as Weapon
onready var sprite_node := $Sprite as Sprite
onready var animation_scale_node := $AnimationScale as AnimationPlayer
onready var animation_move_node := $AnimationMove as AnimationPlayer


func _physics_process(_delta: float) -> void:
    if not visible:
        return

    moving()
    jumping()
    shoot()
    zoom()

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


func shoot() -> void:
    animations.play(velocity, animation_move_node, sprite_node)

    var center_y := position.y - OFFSET_NORMAL_SHAPE if shape.is_normal_shape else position.y - OFFSET_SMALL_SHAPE;
    var player_center := Vector2(position.x, center_y)
    weapon_node.play(animation_move_node, sprite_node, player_center)


func zoom() -> void:
    if is_can_zoom_out:
        shape.switch_scale(animation_scale_node)

    elif shape.is_normal_shape:
        scale = shape.force_to_small_shape(animation_scale_node)


# external call
func zoom_out(flag: bool) -> void:
    is_can_zoom_out = flag


# external call
func game_over() -> void:
    visible = false
