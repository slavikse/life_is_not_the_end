extends Node

export(PackedScene) var Level01Scene: PackedScene


func _ready() -> void:
    #warning-ignore:return_value_discarded
    get_tree().change_scene_to(Level01Scene)
