extends Node2D

# Индекс музыки сопоставляется с индексом уровня.
# Если значение по индексу не меняется, значит трек продолжает играть.
export var levels_count := 1
export var embients_each := 1

const LEVELS := []
const EMBIENTS := []

const LEVELS_FILE_NAME := "user://levels.bin"
const RERUNS := {}

var current_level_number := 1
var previous_embient_number := -1
var maximum_level_number := -1

var is_game_started := false
var is_need_change_level := false
var is_need_reload_level := false

onready var embient_audio_node := $Embient as AudioStreamPlayer


func _ready() -> void:
    levels_init()
    restore_level()
    restore_rerun()
    play_embient()


func _process(_delta: float) -> void:
    if is_need_reload_level:
        reload_level()

    elif is_need_change_level:
        change_level()

    if is_game_started and Input.is_action_just_pressed('game_reload_current_scene'):
        reload_level_next_tick()


func levels_init() -> void:
    var embients_index := 1

    for level_index in range(levels_count):
        var level_index_next := level_index + 1
        LEVELS.append(level_index_next)
        EMBIENTS.append(embients_index)

        if level_index_next % embients_each == 0:
            embients_index += 1


func restore_level() -> void:
    var file := File.new() as File

    if file.file_exists(LEVELS_FILE_NAME):
        #warning-ignore:RETURN_VALUE_DISCARDED
        file.open(LEVELS_FILE_NAME, File.READ)
        current_level_number = int(file.get_as_text())
        maximum_level_number = current_level_number

    file.close()


func restore_rerun() -> void:
    var file := File.new() as File
    var file_name := 'user://level_%s.bin' % current_level_number

    if file.file_exists(file_name):
        #warning-ignore:RETURN_VALUE_DISCARDED
        file.open(file_name, File.READ)
        RERUNS[current_level_number] = int(file.get_as_text())

    file.close()


func play_embient() -> void:
    var embient_number := int(EMBIENTS[current_level_number - 1])

    if previous_embient_number != embient_number:
        previous_embient_number = embient_number

        var embient_audio := load('res://scenes/levels/level_%s/embient.ogg' % embient_number) as AudioStream
        embient_audio_node.set_stream(embient_audio)
        embient_audio_node.play()


func reload_level() -> void:
    is_need_reload_level = false
    change_scene()
    save_rerun()


func save_rerun() -> void:
    if RERUNS.get(current_level_number):
        RERUNS[current_level_number] += 1

    else:
        RERUNS[current_level_number] = 1

    var file := File.new() as File
    #warning-ignore:RETURN_VALUE_DISCARDED
    file.open('user://level_%s.bin' % current_level_number, File.WRITE)
    file.store_string(str(RERUNS[current_level_number]))
    file.close()


func change_scene() -> void:
    #warning-ignore:RETURN_VALUE_DISCARDED
    get_tree().change_scene('res://scenes/levels/level_%s/Level.tscn' % current_level_number)
    is_game_started = true


func change_level() -> void:
    is_need_change_level = false
    change_scene()
    play_embient()


func reload_level_next_tick() -> void:
    is_need_reload_level = true


func save_level() -> void:
    var file := File.new() as File
    #warning-ignore:RETURN_VALUE_DISCARDED
    file.open(LEVELS_FILE_NAME, File.WRITE)
    file.store_string(str(maximum_level_number))
    file.close()


func external_start_level(level_number: int) -> void:
    current_level_number = level_number
    is_need_change_level = true

    if level_number > maximum_level_number:
        maximum_level_number = level_number
        save_level()


func external_next_level() -> void:
    if current_level_number < LEVELS.size():
        external_start_level(current_level_number + 1)

    else:
        current_level_number = 1
        GlobalMain.external_menu_show()
