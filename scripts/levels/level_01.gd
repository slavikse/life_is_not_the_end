extends Node2D

export(PackedScene) var DeadPlayerScene: PackedScene
onready var dead_player_node := DeadPlayerScene.instance() as RigidBody2D


func _on_Spike_stumbled() -> void:
    call_deferred('add_child', dead_player_node)
