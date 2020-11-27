extends Node2D

# TODO Добавить стартовый сигнал? Стартовое приветствие - ненавязчивое.

func _process(_delta: float) -> void:
    if Input.is_action_just_pressed('ui_reload_current_scene'):
        #warning-ignore:return_value_discarded
        get_tree().reload_current_scene()
