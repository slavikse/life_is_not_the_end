extends StaticBody2D

class_name Door

onready var animation_player_node := $AnimationPlayer as AnimationPlayer


func open() -> void:
    animation_player_node.play('open')
