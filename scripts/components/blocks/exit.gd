extends Area2D

class_name Exit

onready var animation_player_node := $AnimationPlayer as AnimationPlayer


func open() -> void:
    animation_player_node.play('open')


# Предположительно ошибка в Godot. Сюда приходит уведомление только с типом Player.
# Если указать тип Player вызовет ошибку циклической ссылки.
func _on_Exit_body_entered(player_node: KinematicBody2D) -> void:
    if player_node:
        # TODO разрушение после того, как игрой зайдет в тардис и полетит.
        get_tree().call_group('Block', 'force_destroy')
