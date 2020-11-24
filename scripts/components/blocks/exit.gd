extends Area2D

class_name Exit

var is_can_out := false

onready var animation_player_node := $AnimationPlayer as AnimationPlayer


# external call
func open() -> void:
    is_can_out = true
    animation_player_node.play('open')


func _on_Exit_body_entered(player_node: Player) -> void:
    if player_node and is_can_out:
        # TODO разрушение после того, как игрой зайдет в тардис и полетит.
        get_tree().call_group('Block', 'force_swap')
