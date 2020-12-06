extends GridContainer


# TODO пока не начата игра, все хоткеи не должны рагировать
# TODO вызов этого меню по ESC из игры.

func _on_NewGame_pressed() -> void:
    visible = false # TODO не скрывается
    Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
    GlobalController.external_start_level(1)


func _on_Exit_pressed() -> void:
    get_tree().quit()
