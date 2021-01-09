extends Node2D

var is_menu_shown := true
var is_submenu_shown := false
var is_manual_level_change := false

# 0: Play, 1: Levels, 2: Options, 3: Credits
var menu_button_active_index := 0
var levels_button_active_index := 0
var credits_link_active_index := 0

const LEVELS_BUTTONS_SCROLL_STEP := 46
var levels_buttons := []
var credits_links := []

const VOLUME_STEP := 25
var volume := 75
var volume_file_name := "user://volume.bin"

onready var menu_camera_node := $Menu/Camera as Camera2D
onready var menu_play_node := $Menu/Actions/Play as Button
onready var menu_levels_node := $Menu/Actions/Levels as Button
onready var menu_options_node := $Menu/Actions/Options as Button
onready var menu_credits_node := $Menu/Actions/Credits as Button
onready var menu_exit_node := $Menu/Actions/Exit as Button
onready var menu_buttons := [menu_play_node, menu_levels_node, menu_options_node, menu_credits_node, menu_exit_node]

onready var levels_camera_node := $Levels/Camera as Camera2D
onready var levels_return_node := $Levels/Return as Button
onready var levels_button_template_node := $Levels/Level_button_template as Button
onready var levels_buttons_scroll_container := $Levels/ScrollContainer as ScrollContainer
onready var levels_buttons_container_node := $Levels/ScrollContainer/VBoxContainer as VBoxContainer

onready var options_camera_node := $Options/Camera as Camera2D
onready var options_return_node := $Options/Return as Button
onready var options_volume_node := $Options/Volume as Button

onready var credits_camera_node := $Credits/Camera as Camera2D
onready var credits_return_node := $Credits/Return as Button
onready var credits_links_container_node := $Credits/Links as Node2D

onready var game_end_camera_node := $GameEnd/Camera as Camera2D
onready var game_end_return_node := $GameEnd/Return as Button


func _ready() -> void:
    restore_volume()
    _on_Volume_pressed(0)

    change_button_active(menu_button_active_index, menu_buttons)


func _process(_delta: float) -> void:
    if is_submenu_shown:
        if Input.is_action_just_pressed('ui_menu'):
            return_from_submenu()

        else:
            if menu_button_active_index == 1:
                ui_levels_controls()

            elif menu_button_active_index == 2:
                ul_volume()

            elif menu_button_active_index == 3:
                ui_credits()

    else:
        if is_menu_shown:
            ui_menu_controls()

        if GlobalController.is_game_started:
            ui_menu()


func restore_volume() -> void:
    var file := File.new() as File

    if file.file_exists(volume_file_name):
        #warning-ignore:RETURN_VALUE_DISCARDED
        file.open(volume_file_name, File.READ)
        volume = int(file.get_as_text())

    file.close()


func return_from_submenu() -> void:
    levels_return_node.emit_signal('pressed')
    options_return_node.emit_signal('pressed')
    credits_return_node.emit_signal('pressed')
    game_end_return_node.emit_signal('pressed')


func ui_levels_controls() -> void:
    if Input.is_action_just_pressed('ui_arrow_top'):
        levels_button_active_index = prev_button_active(levels_button_active_index, levels_buttons)
        change_button_active(levels_button_active_index, levels_buttons)

        levels_buttons_scroll_container.scroll_vertical -= LEVELS_BUTTONS_SCROLL_STEP

        if levels_button_active_index == -1:
            levels_button_active_index = GlobalController.maximum_level_number - 1

        update_scroll_vertical()

    elif Input.is_action_just_pressed('ui_arrow_bottom'):
        levels_button_active_index = next_button_active(levels_button_active_index, levels_buttons)
        change_button_active(levels_button_active_index, levels_buttons)

        levels_buttons_scroll_container.scroll_vertical += LEVELS_BUTTONS_SCROLL_STEP

        if levels_button_active_index == GlobalController.maximum_level_number:
            levels_button_active_index = 0

        update_scroll_vertical()

    elif Input.is_action_just_pressed('ui_enter'):
        levels_buttons[levels_button_active_index].emit_signal('pressed')


func update_scroll_vertical() -> void:
    change_button_active(levels_button_active_index, levels_buttons)
    levels_buttons_scroll_container.scroll_vertical = levels_button_active_index * LEVELS_BUTTONS_SCROLL_STEP


func ui_menu_controls() -> void:
    if Input.is_action_just_pressed('ui_arrow_top'):
        menu_button_active_index = prev_button_active(menu_button_active_index, menu_buttons)
        change_button_active(menu_button_active_index, menu_buttons)

    elif Input.is_action_just_pressed('ui_arrow_bottom'):
        menu_button_active_index = next_button_active(menu_button_active_index, menu_buttons)
        change_button_active(menu_button_active_index, menu_buttons)

    elif Input.is_action_just_pressed('ui_enter'):
        menu_buttons[menu_button_active_index].emit_signal('pressed')


func prev_button_active(button_active_index: int, buttons: Array) -> int:
    if button_active_index > 0:
        button_active_index -= 1

    else:
        button_active_index = buttons.size() - 1

    return button_active_index


func next_button_active(button_active_index: int, buttons: Array) -> int:
    if button_active_index < buttons.size() - 1:
        button_active_index += 1

    else:
        button_active_index = 0

    return button_active_index


func change_button_active(button_active_index: int, buttons: Array) -> void:
    for button in buttons:
        button.add_color_override('font_color', '#102027')

    # Два типа: Button, LinkButton.
    var button = buttons[button_active_index]
    button.add_color_override('font_color', '#cfd8dc')


func ul_volume() -> void:
    if Input.is_action_just_pressed('ui_left'):
        _on_Volume_pressed(-25)

    if Input.is_action_just_pressed('ui_right'):
        _on_Volume_pressed(25)


func ui_credits() -> void:
    if Input.is_action_just_pressed('ui_arrow_top'):
        credits_link_active_index = prev_button_active(credits_link_active_index, credits_links)
        change_button_active(credits_link_active_index, credits_links)

    elif Input.is_action_just_pressed('ui_arrow_bottom'):
        credits_link_active_index = next_button_active(credits_link_active_index, credits_links)
        change_button_active(credits_link_active_index, credits_links)

    elif Input.is_action_just_pressed('ui_enter'):
        credits_links[credits_link_active_index].emit_signal('pressed')


func ui_menu() -> void:
    if Input.is_action_just_pressed('ui_menu'):
        is_menu_shown = !is_menu_shown

        if is_menu_shown:
            game_paused()

        else:
            _on_Start_pressed()

    if is_manual_level_change:
        is_manual_level_change = false
        active_player_camera()


func game_paused() -> void:
    get_tree().paused = true
    menu_camera_node.current = true

    menu_button_active_index = 0
    change_button_active(menu_button_active_index, menu_buttons)

    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_Start_pressed() -> void:
    get_tree().paused = false

    if GlobalController.is_game_started:
        game_continue()

    else:
        game_start()


func game_continue() -> void:
    is_menu_shown = false
    is_submenu_shown = false

    Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
    active_player_camera()


func active_player_camera() -> void:
    if GlobalController.is_game_started:
        var level_node := get_node_or_null('/root/Level') as Level

        if level_node:
            var player_camera_node := level_node.get_node('Player/Camera') as Camera2D
            player_camera_node.current = true

        else:
            is_manual_level_change = true


func game_start(level := 0) -> void:
    var current_level_number := GlobalController.current_level_number if level == 0 else level

    GlobalController.external_start_level(current_level_number)
    game_continue()

    yield(get_tree().create_timer(0.1), 'timeout')
    menu_play_node.text = 'RESUME'


func _on_Volume_pressed(value := VOLUME_STEP) -> void:
    volume += value

    if volume < 0:
        volume = VOLUME_STEP * 4

    elif volume > VOLUME_STEP * 4:
        volume = 0

    options_volume_node.text = str(volume)

    save_volume()

    var bus_idx := AudioServer.get_bus_index("Master")

    if volume == 0:
        AudioServer.set_bus_volume_db(bus_idx, -80)

    elif volume == VOLUME_STEP:
        AudioServer.set_bus_volume_db(bus_idx, -20)

    elif volume == VOLUME_STEP * 2:
        AudioServer.set_bus_volume_db(bus_idx, -10)

    elif volume == VOLUME_STEP * 3:
        AudioServer.set_bus_volume_db(bus_idx, 0)

    elif volume == VOLUME_STEP * 4:
        AudioServer.set_bus_volume_db(bus_idx, 10)


func save_volume() -> void:
    var file := File.new() as File
    #warning-ignore:RETURN_VALUE_DISCARDED
    file.open(volume_file_name, File.WRITE)
    file.store_string(str(volume))
    file.close()


func _on_Return_pressed() -> void:
    is_menu_shown = true
    is_submenu_shown = false

    menu_camera_node.current = true


func _on_Levels_pressed() -> void:
    menu_button_active_index = 1
    change_button_active(menu_button_active_index, menu_buttons)

    levels_camera_node.current = true
    is_submenu_shown = true

    update_levels_buttons()

    levels_button_active_index = GlobalController.current_level_number - 1
    levels_buttons = levels_buttons_container_node.get_children()

    change_button_active(levels_button_active_index, levels_buttons)

    yield(get_tree().create_timer(0.001), 'timeout')
    levels_buttons_scroll_container.scroll_vertical = levels_button_active_index * LEVELS_BUTTONS_SCROLL_STEP


func update_levels_buttons() -> void:
    for level_button_node in levels_buttons_container_node.get_children():
        levels_buttons_container_node.remove_child(level_button_node)

    for level_button_index in range(GlobalController.maximum_level_number):
        var levels_button_count := int(level_button_index) + 1
        var level_button_node := levels_button_template_node.duplicate() as Button

        #warning-ignore:RETURN_VALUE_DISCARDED
        level_button_node.connect('pressed', self, '_on_Level_pressed', [levels_button_count])
        level_button_node.show()

        if levels_button_count < 10:
            level_button_node.text = "LEVEL 0%s" % str(levels_button_count)

        else:
            level_button_node.text = "LEVEL %s" % str(levels_button_count)

        if levels_button_count < GlobalController.maximum_level_number:
            var complete_node := level_button_node.get_node('Complete') as Polygon2D
            complete_node.show()

        levels_buttons_container_node.add_child(level_button_node)


func _on_Level_pressed(level: int) -> void:
    get_tree().paused = false
    game_start(level)

    is_menu_shown = false
    is_submenu_shown = false

    is_manual_level_change = true


func _on_Options_pressed() -> void:
    menu_button_active_index = 2
    change_button_active(menu_button_active_index, menu_buttons)

    options_camera_node.current = true
    is_submenu_shown = true


func _on_Credits_pressed() -> void:
    menu_button_active_index = 3
    change_button_active(menu_button_active_index, menu_buttons)

    credits_links = credits_links_container_node.get_children()
    change_button_active(credits_link_active_index, credits_links)

    credits_camera_node.current = true
    is_submenu_shown = true


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
    OS.shell_open('https://fontlibrary.org/en/font/pixel-operator')


func _on_Author_pressed() -> void:
    #warning-ignore:RETURN_VALUE_DISCARDED
    OS.shell_open('https://pixsynt.ru')


func _on_Exit_pressed() -> void:
    get_tree().quit()


func external_game_end() -> void:
    menu_play_node.text = 'PLAY'
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

    menu_button_active_index = 0
    change_button_active(menu_button_active_index, menu_buttons)

    game_end_camera_node.current = true
    is_submenu_shown = true
