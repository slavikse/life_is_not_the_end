extends Node2D

export(PackedScene) var DeadPlayerScene: PackedScene

onready var dead_player_node := DeadPlayerScene.instance() as Node2D


func _on_Spike_game_over() -> void:
    call_deferred('add_child', dead_player_node)

    yield(get_tree().create_timer(2), 'timeout')
    #warning-ignore:return_value_discarded
    get_tree().reload_current_scene()
