extends StaticBody2D

class_name Candle

onready var door_node := $'/root/Level/World/ClosedRoom/Door' as Door
onready var animation_player_node := $AnimationPlayer as AnimationPlayer

var is_not_triggered := true


func ignite() -> void:
    if is_not_triggered:
        is_not_triggered = false

        animation_player_node.play('fire')
        door_node.open()
