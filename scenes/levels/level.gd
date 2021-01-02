extends Node2D

class_name Level

export(PackedScene) var DeadPlayerScene: PackedScene

onready var exit_node := $Exit as Exit
onready var rooms_node := $Rooms as Node2D
onready var tips_rerun_node := $Tips/Rerun as Label
onready var closed_doors := rooms_node.get_child_count() + 1
onready var is_character_not_added := true


func _ready() -> void:
    if GlobalController.RERUNS.get(GlobalController.current_level_number):
        tips_rerun_node.text = str(GlobalController.RERUNS[GlobalController.current_level_number])


func _on_RerunTime_timeout() -> void:
    tips_rerun_node.hide()


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
