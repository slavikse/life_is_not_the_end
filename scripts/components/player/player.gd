extends KinematicBody2D

class_name Player

var move := preload('./movement/move.gd').new()
var jump := preload('./movement/jump.gd').new()
var shape := preload('./transform/shape.gd').new()
var animations := preload('./transform/animations.gd').new()

const FLOOR := Vector2.UP
var velocity := Vector2.ZERO;

var is_stumbled := false
var is_can_zoom_out := true

onready var sprite_node := $Sprite as Sprite
onready var animation_scale_node := $AnimationScale as AnimationPlayer
onready var animation_move_node := $AnimationMove as AnimationPlayer
onready var weapon_node := $Weapon as Weapon


func _physics_process(_delta: float) -> void:
    if is_stumbled:
        return

    if is_can_zoom_out:
        shape.switch_scale(animation_scale_node)

    moving()
    jumping()
    shoot()

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

    var center_y := position.y - 4 * 8 if shape.is_normal_shape else position.y - 2 * 8;
    var player_center := Vector2(position.x, center_y)
    weapon_node.play(animation_move_node, sprite_node, player_center)


func zoom_out(flag: bool) -> void:
    is_can_zoom_out = flag

    if not is_can_zoom_out and shape.is_normal_shape:
        scale = shape.force_to_small_shape(animation_scale_node)


func game_over() -> void:
    visible = false
    is_stumbled = true
