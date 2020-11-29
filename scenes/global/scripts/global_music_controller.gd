extends Node2D

onready var sound_audio_node := $Sound as AudioStreamPlayer


func play_sound(audio_stream: AudioStream) -> void:
    sound_audio_node.set_stream(audio_stream)
    sound_audio_node.play(0)
