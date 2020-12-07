extends KinematicBody2D

class_name Player

const FLOOR := Vector2.UP
const OFFSET_NORMAL_SHAPE := 4 * 8
const OFFSET_SMALL_SHAPE := 2 * 8

var move := preload('./movement/move.gd').new()
var jump := preload('./movement/jump.gd').new()
var shape := preload('./transform/shape.gd').new()
var animations := preload('./transform/animations.gd').new()

var velocity := Vector2.ZERO;
# 1 - Когда только что приземлился. Больше 1, когда стоит на полу.
var is_landed_counter := 0
var is_can_zoom_out := true
var is_level_complete := false

onready var weapon_node := $Weapon as Weapon
onready var sprite_node := $Sprite as Sprite
onready var collision_node := $Collision as CollisionPolygon2D
onready var scale_animation_node := $Scale as AnimationPlayer
onready var move_animation_node := $Move as AnimationPlayer
onready var floor_audio_node := $Floor as AudioStreamPlayer2D
onready var zoom_audio_node := $Zoom as AudioStreamPlayer2D


func _ready() -> void:
    scale = Vector2(0, 0)
    scale_animation_node.play('shape_zero_to_normal')


func _physics_process(_delta: float) -> void:
    if is_level_complete:
        Input.action_release('ui_up')
        Input.action_release('ui_left')
        Input.action_release('ui_right')

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

    has_landing()


func has_landing() -> void:
    if round(velocity.y) == jump.N_GRAVITY:
        is_landed_counter += 1

        if is_landed_counter == 1:
            floor_audio_node.play()

    else:
        is_landed_counter = 0


func shoot() -> void:
    animations.play(velocity, move_animation_node, sprite_node)

    var center_y := position.y - OFFSET_NORMAL_SHAPE if shape.is_normal_shape else position.y - OFFSET_SMALL_SHAPE;
    var player_center := Vector2(position.x, center_y)
    weapon_node.external_shot(move_animation_node, sprite_node, player_center)


func zoom() -> void:
    if is_can_zoom_out:
        var is_resize := shape.switch_scale(scale_animation_node)

        if is_resize:
            zoom_audio_node.play()

    elif shape.is_normal_shape:
        scale = shape.force_to_small_shape(scale_animation_node)
        zoom_audio_node.play()


func external_zoom_out(flag: bool) -> void:
    is_can_zoom_out = flag


func external_game_over() -> void:
    collision_node.set_deferred('disabled', true)
    visible = false


func external_level_complete() -> void:
    is_level_complete = true

    if shape.is_normal_shape:
        scale_animation_node.play('shape_normal_to_zero')

    else:
        scale_animation_node.play('shape_small_to_zero')

    yield(scale_animation_node, 'animation_finished')
    visible = false

    yield(get_tree().create_timer(0.3), 'timeout')

    if GlobalController:
        GlobalController.external_next_level()
