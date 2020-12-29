extends Node2D

class_name Level

export(PackedScene) var DeadPlayerScene: PackedScene

var closed_doors := 2

onready var exit_node := $Exit as Exit
onready var is_character_not_added := true


func external_can_activate_exit() -> void:
    if closed_doors == 0:
        return

    closed_doors -= 1

    if closed_doors == 0:
        exit_node.external_open()


func external_game_over() -> void:
    if is_character_not_added:
        is_character_not_added = false

        var dead_player_node := DeadPlayerScene.instance() as DeadPlayer
        call_deferred('add_child', dead_player_node)
