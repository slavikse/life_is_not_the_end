extends Node2D

var self_scale: Vector2

onready var player_node := $'/root/Level/Player' as KinematicBody2D
onready var player_sprite_node := player_node.get_node('Sprite') as Sprite

onready var body_node := $RigidBody2D as RigidBody2D
onready var sprite_node := $RigidBody2D/Sprite as Sprite
onready var collision_shape_node := $RigidBody2D/CollisionShape2D as CollisionShape2D


func _ready() -> void:
    position = player_node.position
    # warning-ignore:unsafe_property_access
    body_node.set_linear_velocity(player_node.velocity)
    sprite_node.flip_h = player_sprite_node.flip_h


# warning-ignore:unused_argument
func _process(delta: float) -> void:
    if player_node:
        self_scale = player_node.scale

    sprite_node.scale = self_scale
    collision_shape_node.scale = self_scale
