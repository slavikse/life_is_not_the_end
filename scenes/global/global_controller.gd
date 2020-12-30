extends Node2D

const levels := [1, 2]
# Индекс музыки сопоставляется с индексом уровня. Если не поменялся, значит продолжает играть текущий трек.
const embients := [1, 1]

var change_level_number := 1
var previous_embient_number := -1

var is_game_started := false
var is_need_change_level := false
var is_need_reload_level := false

onready var embient_audio_node := $Embient as AudioStreamPlayer


func _ready() -> void:
    play_embient()


func _process(_delta: float) -> void:
    if is_need_reload_level:
        reload_level()

    elif is_need_change_level:
        change_level()

    if is_game_started:
        if Input.is_action_just_pressed('game_reload_current_scene'):
            reload_level_next_tick()


func reload_level() -> void:
    is_need_reload_level = false
    change_scene()


func change_scene() -> void:
    #warning-ignore:RETURN_VALUE_DISCARDED
    get_tree().change_scene('res://scenes/levels/level_%s/Level.tscn' % change_level_number)
    is_game_started = true


func change_level() -> void:
    is_need_change_level = false
    change_scene()
    play_embient()


func play_embient() -> void:
    var embient_number := int(embients[change_level_number - 1])

    if previous_embient_number != embient_number:
        previous_embient_number = embient_number

        var embient_audio := load('res://scenes/levels/level_%s/embient.ogg' % embient_number) as AudioStream
        embient_audio_node.set_stream(embient_audio)
        embient_audio_node.play()


func reload_level_next_tick() -> void:
    is_need_reload_level = true


# TODO сохранять максимальный уровень прохождения на диске и восстанавливать при запуске игры
func external_start_level(level_number: int) -> void:
    change_level_number = level_number
    is_need_change_level = true


func external_next_level() -> void:
    if change_level_number < levels.size():
        external_start_level(change_level_number + 1)

    else:
        GlobalMain.external_menu_show()
