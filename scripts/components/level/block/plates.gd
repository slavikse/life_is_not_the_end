extends Node

signal plate_entered(value)


func _on_Plate_Top_body_entered(body: KinematicBody2D) -> void:
    emit_signal('plate_entered', 'top')


func _on_Plate_Right_body_entered(body: KinematicBody2D) -> void:
    emit_signal('plate_entered', 'right')


func _on_Plate_Bottom_body_entered(body: KinematicBody2D) -> void:
    emit_signal('plate_entered', 'bottom')


func _on_Plate_Left_body_entered(body: KinematicBody2D) -> void:
    emit_signal('plate_entered', 'left')
