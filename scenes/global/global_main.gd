extends Node2D

var is_menu_shown := true
var button_active_index := -1
var is_overlay_shown := false

var volume := 75
var volume_file_name := "user://logs.bin"

onready var camera_node := $Menu/Camera as Camera2D
onready var play_node := $Menu/Actions/Play as Button
onready var levels_node := $Menu/Actions/Levels as Button
onready var options_node := $Menu/Actions/Options as Button
onready var credits_node := $Menu/Actions/Credits as Button
onready var exit_node := $Menu/Actions/Exit as Button
onready var buttons := [play_node, levels_node, options_node, credits_node, exit_node]

onready var levels_camera_node := $Levels/Camera as Camera2D
onready var levels_return_node := $Levels/Return as Button

onready var options_camera_node := $Options/Camera as Camera2D
onready var options_return_node := $Options/Return as Button
onready var options_volume_node := $Options/Volume as Button

onready var credits_camera_node := $Credits/Camera as Camera2D
onready var credits_return_node := $Credits/Return as Button


# В меню LEVELS, будут открыты все уровени до (включительно) максимально доступного взятого с диска.
# если игра начинается с уровня из этого списка или текущая игра переключается на другой уровень из списка,
# то должно должно корректно отрабатывать.
func _ready() -> void:
    restore_save_game()
    next_button_active()
    _on_Volume_pressed(0)


func _process(_delta: float) -> void:
    if is_overlay_shown:
        if Input.is_action_just_pressed('ui_enter') or Input.is_action_just_pressed('ui_menu'):
            levels_return_node.emit_signal('pressed')
            options_return_node.emit_signal('pressed')
            credits_return_node.emit_signal('pressed')

        if Input.is_action_just_pressed('ui_left'):
            _on_Volume_pressed(-25)

        if Input.is_action_just_pressed('ui_right'):
            _on_Volume_pressed(25)

        return

    if is_menu_shown:
        ui_controls()

    if GlobalController.is_game_started and Input.is_action_just_pressed('ui_menu'):
        is_menu_shown = !is_menu_shown

        if is_menu_shown:
            game_paused()

        else:
            _on_Start_pressed()


func restore_save_game() -> void:
    var file := File.new() as File

    if file.file_exists(volume_file_name):
        #warning-ignore:RETURN_VALUE_DISCARDED
        file.open(volume_file_name, File.READ)
        volume = int(file.get_as_text())

    file.close()


func ui_controls() -> void:
    if Input.is_action_just_pressed('ui_arrow_top'):
        prev_button_active()

    if Input.is_action_just_pressed('ui_arrow_bottom'):
        next_button_active()

    if Input.is_action_just_pressed('ui_enter'):
        buttons[button_active_index].emit_signal('pressed')


func prev_button_active() -> void:
    if button_active_index > 0:
        button_active_index -= 1

    else:
        button_active_index = buttons.size() - 1

    change_button_active()


func next_button_active() -> void:
    if button_active_index < buttons.size() - 1:
        button_active_index += 1

    else:
        button_active_index = 0

    change_button_active()


func change_button_active() -> void:
    for button in buttons:
        button.add_color_override('font_color', '#102027')

    #warning-ignore:UNSAFE_CAST
    var button := buttons[button_active_index] as Button
    button.add_color_override('font_color', '#cfd8dc')


func game_paused() -> void:
    get_tree().paused = true
    camera_node.current = true

    button_active_index = -1
    next_button_active()

    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_Start_pressed() -> void:
    get_tree().paused = false

    if GlobalController.is_game_started:
        game_continue()

    else:
        game_start()


func game_start() -> void:
    GlobalController.external_start_level(GlobalController.change_level_number)
    game_continue()

    yield(get_tree().create_timer(0.1), 'timeout')
    play_node.text = 'Resume'


func game_continue() -> void:
    is_menu_shown = false
    Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

    if GlobalController.is_game_started:
        var player_camera_node := $'/root/Level/Player/Camera' as Camera2D
        player_camera_node.current = true


func _on_Volume_pressed(value := 25) -> void:
    volume += value

    if volume < 0:
        volume = 100

    elif volume > 100:
        volume = 0

    options_volume_node.text = str(volume)
    save_game()

    var bus_idx := AudioServer.get_bus_index("Master")

    if volume == 0:
        AudioServer.set_bus_volume_db(bus_idx, -80)

    elif volume == 25:
        AudioServer.set_bus_volume_db(bus_idx, -20)

    elif volume == 50:
        AudioServer.set_bus_volume_db(bus_idx, -10)

    elif volume == 75:
        AudioServer.set_bus_volume_db(bus_idx, 0)

    elif volume == 100:
        AudioServer.set_bus_volume_db(bus_idx, 10)


func save_game() -> void:
    var file := File.new() as File
    #warning-ignore:RETURN_VALUE_DISCARDED
    file.open(volume_file_name, File.WRITE)
    file.store_string(str(volume))
    file.close()


func _on_Levels_pressed() -> void:
    levels_camera_node.current = true
    is_overlay_shown = true


func _on_Options_pressed() -> void:
    options_camera_node.current = true
    is_overlay_shown = true


func _on_Credits_pressed() -> void:
    credits_camera_node.current = true
    is_overlay_shown = true


func _on_Return_pressed() -> void:
    camera_node.current = true
    is_overlay_shown = false


func _on_Author_pressed() -> void:
    #warning-ignore:RETURN_VALUE_DISCARDED
    OS.shell_open('https://pixsynt.ru')


func _on_GodotLink_pressed() -> void:
    #warning-ignore:RETURN_VALUE_DISCARDED
    OS.shell_open('https://godotengine.org')


func _on_AbmientsLink_pressed() -> void:
    #warning-ignore:RETURN_VALUE_DISCARDED
    OS.shell_open('https://incompetech.com/music/royalty-free/music.html')


func _on_EffectsLink_pressed() -> void:
    #warning-ignore:RETURN_VALUE_DISCARDED
    OS.shell_open('https://kenney.nl/assets?q=audio')


func _on_FontLink_pressed() -> void:
    #warning-ignore:RETURN_VALUE_DISCARDED
    OS.shell_open('https://www.fonts-online.ru/font/Overlorder')


func _on_Exit_pressed() -> void:
    get_tree().quit()


# TODO показать что то, что игра пройдена. Спасибо за покупку игры и тд.
# TODO вместо надписи продолжить, будет start и игра начнется с последнего уровня
func external_menu_show() -> void:
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

    camera_node.current = true
    is_menu_shown = true
