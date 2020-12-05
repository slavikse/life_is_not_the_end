extends Node2D

const levels := [1, 2, 3]
# Индекс музыки сопоставляется с индексом уровня. Если не поменялся, значит продолжает играть текущий трек.
const embients := [1, 1, 1]

# TODO при смене уровня через меню уровней (плитка с уровнями), нужно изменить значения и здесь!
var change_level_number := -1
var previous_embient_number := -1

var is_need_change_level := false
var is_need_reload_level := false

var external_is_not_level_started := false

onready var loader_node := $Loader as Node2D
onready var embient_audio_node := $Embient as AudioStreamPlayer


func _ready() -> void:
    loader_node.hide()


func _process(_delta: float) -> void:
    if is_need_reload_level:
        reload_level()

    elif is_need_change_level:
        change_level()

    if Input.is_action_just_pressed('ui_reload_current_scene'):
        reload_level_next_tick()


func reload_level() -> void:
    is_need_reload_level = false
    change_scene()


func change_scene() -> void:
    external_is_not_level_started = true
    #warning-ignore: RETURN_VALUE_DISCARDED
    get_tree().change_scene('res://scenes/levels/level_%s/Level.tscn' % change_level_number)
    loader_node.hide()


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

    var player_node := $'/root/Level/Player' as Player
    show_loader(player_node.position)


func show_loader(position: Vector2) -> void:
    loader_node.position = position
    loader_node.show()


func external_start_level(level_number: int) -> void:
    change_level_number = level_number
    is_need_change_level = true
    # TODO работает?
    show_loader(Vector2())


func external_next_level() -> void:
    if change_level_number < levels.size():
        external_start_level(change_level_number + 1)

    # TODO выход в меню. последний уровень завершён
    else:
        external_start_level(change_level_number)
