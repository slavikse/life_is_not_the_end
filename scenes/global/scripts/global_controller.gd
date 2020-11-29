extends Node2D

onready var embient_audio_node := $Embient as AudioStreamPlayer


func _process(_delta: float) -> void:
    if Input.is_action_just_pressed('ui_reload_current_scene'):
        #warning-ignore:return_value_discarded
        get_tree().reload_current_scene()


func external_start_level(level_number: String) -> void:
    # TODO загружать через yield?
    var LevelScene := load('res://scenes/levels/level_%s/Level.tscn' % level_number) as PackedScene
    var embient_audio := load('res://scenes/levels/level_%s/sounds/embient.ogg' % level_number) as AudioStream

    #warning-ignore:return_value_discarded
    get_tree().change_scene_to(LevelScene)

#    yield(get_tree().create_timer(0.1), 'timeout')
    embient_audio_node.set_stream(embient_audio)
    embient_audio_node.play()
