extends StaticBody2D

class_name Activation

var is_activated := false

onready var animation_player_node := $AnimationPlayer as AnimationPlayer
onready var exit_node := $'/root/Level/Exit' as Exit


func _on_Area2D_body_entered(bullet_node: Bullet) -> void:
    if bullet_node and not is_activated:
        is_activated = true

        animation_player_node.play('open')
        exit_node.open()
