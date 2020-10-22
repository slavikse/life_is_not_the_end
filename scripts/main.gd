extends Node

export(PackedScene) var level_01: PackedScene


func _ready() -> void:
    #warning-ignore:return_value_discarded
    get_tree().change_scene_to(level_01)
