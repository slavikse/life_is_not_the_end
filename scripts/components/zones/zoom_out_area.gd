extends Area2D

signal zoom_out(status)


func _on_ZoomOutArea_body_entered(body: KinematicBody2D) -> void:
    if body:
        emit_signal('zoom_out', 'disabled')


func _on_ZoomOutArea_body_exited(body: KinematicBody2D) -> void:
    if body:
        emit_signal('zoom_out', 'enabled')
