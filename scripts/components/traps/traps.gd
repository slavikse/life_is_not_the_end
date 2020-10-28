extends Area2D

signal game_over


func _on_Spike_body_entered(body: KinematicBody2D) -> void:
    if body:
        emit_signal('game_over')
