extends GridContainer

var is_menu_shown := true

onready var camera_node := $Camera as Camera2D
onready var start_node := $HBoxContainer/VBoxContainer/HBoxContainer2/Start as Button
onready var exit_node := $HBoxContainer/VBoxContainer/HBoxContainer2/Exit as Button
onready var buttons := [start_node, exit_node]

var button_active_index := -1

# TODO кнопка уровни: выводит на список уровней. в начале будет открыт только первый.
#   выбор уровня и мышью и клавиатурой

func _ready() -> void:
    Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
    next_button_active()


func _process(_delta: float) -> void:
    if is_menu_shown:
        ui_controls()

    if GlobalController.is_game_started and Input.is_action_just_pressed('ui_menu'):
        is_menu_shown = !is_menu_shown

        if is_menu_shown:
            game_paused()

        else:
            _on_Start_pressed()


func ui_controls() -> void:
    if Input.is_action_just_pressed('ui_arrow_top'):
        prev_button_active()

    if Input.is_action_just_pressed('ui_arrow_bottom'):
        next_button_active()

    if Input.is_action_just_pressed('ui_select'):
        buttons[button_active_index].emit_signal('pressed')


func prev_button_active() -> void:
    if button_active_index > 0:
        button_active_index -= 1
        change_button_active()


func next_button_active() -> void:
    if button_active_index < buttons.size() - 1:
        button_active_index += 1
        change_button_active()


func change_button_active() -> void:
    for button in buttons:
        button.add_color_override('font_color', '#102027')

    # warning-ignore:UNSAFE_CAST
    var button := buttons[button_active_index] as Button
    button.add_color_override('font_color', '#cfd8dc')


func game_paused() -> void:
    get_tree().paused = true
    camera_node.current = true

    button_active_index = -1
    next_button_active()


func _on_Start_pressed() -> void:
    get_tree().paused = false

    if GlobalController.is_game_started:
        game_continue()

    else:
        game_start()


func game_start() -> void:
    # TODO продолжить уровень. брать сохранение с диска
    GlobalController.external_start_level(1)
    game_continue()

    yield(get_tree().create_timer(0.1), 'timeout')
    start_node.text = 'Resume'


func game_continue() -> void:
    is_menu_shown = false

    if GlobalController.is_game_started:
        var player_camera_node := $'/root/Level/Player/Camera' as Camera2D
        player_camera_node.current = true


func _on_Exit_pressed() -> void:
    get_tree().quit()


# TODO показать что то, что игра пройдена. Спасибо за покупку игры и тд.
func external_menu_show() -> void:
    camera_node.current = true
