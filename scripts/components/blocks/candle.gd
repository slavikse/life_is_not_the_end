extends StaticBody2D

class_name Candle

var is_not_triggered := true

onready var animation_player_node := $AnimationPlayer as AnimationPlayer
onready var level_node := $'/root/Level' as Level
onready var door_node := $'/root/Level/ExitRoom/Door' as Door
onready var exit_node := $'/root/Level/ExitRoom/Exit' as Exit


# Предположительно ошибка в Godot. Сюда приходит уведомление только с типом Player.
# Если указать тип Player вызовет ошибку циклической ссылки.
func _on_FireArea2D_body_entered(player_node: KinematicBody2D) -> void:
    if not is_not_triggered and player_node:
        level_node.game_over()
        #warning-ignore:unsafe_method_access
        player_node.game_over()


# external call
func ignite() -> void:
    if is_not_triggered:
        is_not_triggered = false

        animation_player_node.play('fire')
        door_node.open()
        exit_node.open()
