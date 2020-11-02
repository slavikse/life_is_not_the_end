extends RigidBody2D

const for_center_y_gravity := 5.0 * 8.0

onready var player_node := $'/root/Level/Player' as Player
onready var player_sprite_node := player_node.get_node('Sprite') as Sprite

onready var sprite_node := $Sprite as Sprite
onready var collision_shape_node := $CollisionShape2D as CollisionShape2D


func _ready() -> void:
    position = Vector2(player_node.position.x, player_node.position.y - for_center_y_gravity)

    sprite_node.flip_h = player_sprite_node.flip_h
    sprite_node.scale = player_node.scale
    collision_shape_node.scale = player_node.scale

    set_linear_velocity(player_node.velocity)


# TODO определить, что тело в покое, т.е. упало и больше не двигается и тогда восстановить игрока.
