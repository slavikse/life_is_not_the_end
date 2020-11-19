extends RigidBody2D

class_name Shuriken

onready var level_node := $'/root/Level' as Level


func _on_Area2D_body_entered(player_node: Player) -> void:
    if player_node:
        player_node.game_over()
        level_node.game_over()


func destroy() -> void:
    queue_free()
