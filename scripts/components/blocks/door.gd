extends Node2D

class_name Door

onready var shutters_closed_node := $ShuttersClosed as Node2D

onready var closed_left_shutters_opened_node := $ClosedLeft/Sprite/ShuttersOpened as Node2D
onready var closed_right_shutters_opened_node := $ClosedRight/Sprite/ShuttersOpened as Node2D

onready var shutters_animation_player_node := $ShuttersAnimationPlayer as AnimationPlayer
onready var door_animation_player_node := $DoorAnimationPlayer as AnimationPlayer


# external call
func open() -> void:
    shutters_closed_node.hide()

    closed_left_shutters_opened_node.show()
    closed_right_shutters_opened_node.show()

    shutters_animation_player_node.play('open')
    yield(shutters_animation_player_node, 'animation_finished')

    door_animation_player_node.play('open')
