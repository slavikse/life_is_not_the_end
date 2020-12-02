extends Node2D

var is_need_change_level := false
var is_need_reload_level := false
var change_level_number := '1'

#var levels := ['00', '01']

onready var loader_node := $Loader as Polygon2D
onready var embient_audio_node := $Embient as AudioStreamPlayer


func _ready() -> void:
    loader_node.hide()


func _process(_delta: float) -> void:
    pass
#    if is_need_change_level:
#        change_level()
#
#    elif is_need_reload_level:
#        reload_level()
#
#    if Input.is_action_just_pressed('ui_reload_current_scene'):
#        print(1)
#        #reload_level_next_tick()
#        # TODO
#        get_tree().change_scene_to(load("res://scenes/levels/Level_02.tscn"))


func change_level() -> void:
    is_need_change_level = false
    print('change_level_number', change_level_number)
    change_scene()

    var embient_audio := load('res://scenes/levels/level_%s/audio/embient.ogg' % change_level_number) as AudioStream
    embient_audio_node.set_stream(embient_audio)
    embient_audio_node.play()


func change_scene() -> void:
    #warning-ignore: RETURN_VALUE_DISCARDED
    get_tree().change_scene('res://scenes/levels/level_%s/Level.tscn' % change_level_number)
    loader_node.hide()


func reload_level() -> void:
    is_need_reload_level = false
    change_scene()


func reload_level_next_tick() -> void:
    is_need_reload_level = true
    var player_node := $'/root/Level/Player' as Player
    show_loader(player_node.position)


func show_loader(position: Vector2) -> void:
    loader_node.position = position
    loader_node.show()


func external_change_level(level_number: String) -> void:
    get_tree().change_scene('res://scenes/levels/level_%s/Level.tscn' % level_number)

#    change_level_number = level_number
#    if is_need_change_level:
#        $'/root/Level'.free()

#    var t := load('res://scenes/levels/level_%s/Level.tscn' % change_level_number) as PackedScene
#    get_tree().change_scene('res://scenes/levels/level_%s/Level.tscn' % change_level_number)
#    get_tree().change_scene('res://scenes/levels/level_%s/Level.tscn' % change_level_number)
    # TODO
#    show_loader(Vector2())
#    is_need_change_level = true

# TODO
func external_next_level() -> void:
    pass
