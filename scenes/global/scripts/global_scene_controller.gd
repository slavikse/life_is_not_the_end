extends Node2D


func _ready() -> void:
    external_start_level('01')


func _process(_delta: float) -> void:
    if Input.is_action_just_pressed('ui_reload_current_scene'):
        #warning-ignore:return_value_discarded
        get_tree().reload_current_scene()


func external_start_level(level_number: String) -> void:
    var LevelScene := load('res://scenes/levels/level_%s/Level.tscn' % level_number) as PackedScene
    var audio_stream := load('res://scenes/levels/level_%s/sound.ogg' % level_number) as AudioStream

    #warning-ignore:return_value_discarded
    get_tree().change_scene_to(LevelScene)
    yield(get_tree().create_timer(0.1), 'timeout')
    GlobalMusicController.play_sound(audio_stream)
