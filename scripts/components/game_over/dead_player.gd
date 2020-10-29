extends Node2D

onready var player_node := $'/root/Level/Player' as KinematicBody2D
onready var player_sprite_node := player_node.get_node('Sprite') as Sprite

onready var body_node := $Body as RigidBody2D
onready var sprite_node := $Body/Sprite as Sprite
onready var collision_shape_node := $Body/CollisionShape2D as CollisionShape2D


func _ready() -> void:
    position = player_node.position
    sprite_node.flip_h = player_sprite_node.flip_h


#warning-ignore:unused_argument
func _process(delta: float) -> void:
    body_node.scale = player_node.scale
    # Не наследует масштаб родителя.
    collision_shape_node.scale = player_node.scale
