extends Area2D

class_name Exit

var is_can_out := false

onready var tardis_opened_node := $Tardis/Opened as Sprite
onready var tardis_door_node := $Tardis/Door as Sprite
onready var animation_player_node := $AnimationPlayer as AnimationPlayer


func external_open() -> void:
    is_can_out = true
    tardis_opened_node.show()
    tardis_door_node.show()

    yield(get_tree().create_timer(0.3), 'timeout')
    animation_player_node.play('open')


func _on_Exit_body_entered(player_node: Player) -> void:
    if player_node and is_can_out:
        player_node.external_level_complete()
