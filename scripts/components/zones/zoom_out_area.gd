extends Area2D

signal is_can_zoom_out(flag)


func _on_IsCanZoomOut_body_entered(body: KinematicBody2D) -> void:
    if body:
        emit_signal('is_can_zoom_out', false)


func _on_IsCanZoomOut_body_exited(body: KinematicBody2D) -> void:
    if body:
        emit_signal('is_can_zoom_out', true)
