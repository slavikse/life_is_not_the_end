extends Node2D

onready var player_node := $'/root/Level/Player' as Player
onready var player_sprite_node := player_node.get_node('Sprite') as Sprite

onready var body_node := $'.' as RigidBody2D
onready var sprite_node := $Sprite as Sprite
onready var collision_shape_node := $CollisionShape2D as CollisionShape2D


func _ready() -> void:
    position = player_node.position
    body_node.set_linear_velocity(player_node.velocity)
    sprite_node.flip_h = player_sprite_node.flip_h


#warning-ignore:unused_argument
func _process(delta: float) -> void:
    sprite_node.scale = player_node.scale
    collision_shape_node.scale = player_node.scale

# TODO определить, что тело в покое, т.е. упало и больше не двигается и тогда восстановить игрока.
# TODO две физические капсулы, чтобы ноги были тяжелее
