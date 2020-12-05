extends Node2D


# TODO запуск меню. запуск конкретного уровня.
func _ready() -> void:
    # TODO показать мышь в меню
    Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
    GlobalController.external_start_level(1)
