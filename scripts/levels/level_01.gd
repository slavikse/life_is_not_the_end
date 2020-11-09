extends Node2D

export(PackedScene) var DeadPlayerScene: PackedScene


func _on_Spike_stumbled() -> void:
    var dead_player_node := DeadPlayerScene.instance() as RigidBody2D
    call_deferred('add_child', dead_player_node)
