extends Node2D

class_name Level

export(PackedScene) var DeadPlayerScene: PackedScene

onready var exit_node := $Exit as Exit
onready var rooms_node := $Rooms as Node2D
onready var tips_rerun_node := $Tips/Rerun as Label
onready var closed_doors := rooms_node.get_child_count() + 1
onready var is_character_not_added := true

# Levels / Verified:
# 01 / +
# 02 / +
# 03 / +
# 04 / +
# 05 / +
# 06 / +
# 07 / +
# 08 / +
# 09 / +
# 10 / +
# 11 / +
# 12 / +
# 13 / +
# 14 / +
# 15 / +
# 16 / +
# 17 / +
# 18 / +
# 19 / +
# 20 / +
# 21 / +
# 22 / +
# 23 / +
# 24 / +

# Rooms Used:
# 01 - 1
# 02 - 2
# 03 - 1
# 04 - 2
# 05 - 2
# 06 - 1
# 07 - 2
# 08 - 2
# 09 - 2
# 10 - 3
# 11 - 1
# 12 - 1
# 13 - 2
# 14 - 1
# 15 - 3
# 16 - 2
# 17 - 3
# 18 - 2
# 19 - 1
# 20 - 2
# 21 - 2
# 22 - 2
# 23 - 3
# 24 - 2
# 25 - 1
# 26 - 2
# 27 - 1
# 28 - 1
# 29 - 2
# 30 - 1

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
