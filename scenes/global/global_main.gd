extends GridContainer

var is_menu_shown := false

onready var camera_node := $Camera as Camera2D
onready var continue_node := $HBoxContainer/VBoxContainer/HBoxContainer2/Continue as Button
onready var start_node := $HBoxContainer/VBoxContainer/HBoxContainer2/Start as Button

# TODO кнопка уровни: выводит на список уровней. в начале будет открыт только первый.

func _ready() -> void:
    continue_node.hide()


func _process(_delta: float) -> void:
    if GlobalController.is_game_started:
        if Input.is_action_just_pressed('ui_menu'):
            is_menu_shown = !is_menu_shown

            if is_menu_shown:
                paused()

            else:
                _on_Continue_pressed()


# TODO остановить игру. пауза
func paused() -> void:
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    camera_node.current = true


func _on_Start_pressed() -> void:
    start_node.hide()
    continue_node.show()

    # TODO продолжить уровень. брать сохранение с диска
    GlobalController.external_start_level(1)
    _on_Continue_pressed()


func _on_Continue_pressed() -> void:
    Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
    is_menu_shown = false

    if GlobalController.is_game_started:
        var player_camera_node := $'/root/Level/Player/Camera' as Camera2D
        player_camera_node.current = true


func _on_Exit_pressed() -> void:
    get_tree().quit()


# TODO показать что то, что игра пройдена. Спасибо за покупку игры и тд.
func external_menu_show() -> void:
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    camera_node.current = true
    continue_node.hide()
