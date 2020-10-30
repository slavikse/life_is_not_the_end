extends Area2D

signal stumbled


func _on_Spike_body_entered(body: KinematicBody2D) -> void:
    if body:
        emit_signal('stumbled')
