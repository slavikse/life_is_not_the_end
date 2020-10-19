extends Node


func _ready() -> void:
    #warning-ignore:return_value_discarded
    get_tree().change_scene('res://scenes/levels/level_01.tscn')
