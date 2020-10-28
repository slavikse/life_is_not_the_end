extends Node2D

export(PackedScene) var DeadPlayerScene: PackedScene

onready var player_node := $Player as KinematicBody2D
onready var dead_player_node := DeadPlayerScene.instance() as Node2D


# TODO добавить мертвого игрока с текущей скорость, высотой и положением и направлением.
# TODO если игрок падает на иголку, то там будет Area2D которая будет переопределять свойства физики, чтобы заменённая форма игрока насаживалась.
func _on_Spike_game_over() -> void:
    dead_player_node.position = player_node.position
    # dead_player_node.get_node('Body')

    # TODO применить силу вращения в сторону движения
#    dead_player_node.add_force(Vector2())

    add_child(dead_player_node)
#    dead_player_node - у него есть Body, которому нужно задать ускорение
