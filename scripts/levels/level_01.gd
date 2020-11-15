extends Node2D

class_name Level

export(PackedScene) var DeadPlayerScene: PackedScene

onready var is_character_not_added := true


func game_over() -> void:
    if is_character_not_added:
        is_character_not_added = false

        var dead_player_node := DeadPlayerScene.instance() as RigidBody2D
        call_deferred('add_child', dead_player_node)
