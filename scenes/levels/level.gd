extends Node2D

class_name Level

export(PackedScene) var DeadPlayerScene: PackedScene

onready var is_character_not_added := true


func _ready() -> void:
    if GlobalController.external_is_not_level_started:
        GlobalController.external_is_not_level_started = false

        if GlobalController.change_level_number > 1:
            traversing_levels_in_depth()


func traversing_levels_in_depth() -> void:
    var level_path := '/root'

    for level_index in GlobalController.change_level_number:
        level_path += '/Level'

        if int(level_index) > 0:
            var level_node := get_node(level_path) as Level
            hide_previous_level(level_node)


func hide_previous_level(level_node: Level) -> void:
    level_node.get_node('BackgroundLight').queue_free()
    level_node.get_node('BackgroundBlack').queue_free()
    level_node.get_node('Activation').queue_free()
    level_node.get_node('Exit').queue_free()
    level_node.get_node('Bullets').queue_free()
    level_node.get_node('Player').queue_free()


func external_game_over() -> void:
    if is_character_not_added:
        is_character_not_added = false

        var dead_player_node := DeadPlayerScene.instance() as DeadPlayer
        call_deferred('add_child', dead_player_node)
