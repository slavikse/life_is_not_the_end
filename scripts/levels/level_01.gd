extends Node2D

onready var player_node := $Player as KinematicBody2D
onready var game_over_node := $GameOver as Node2D


func _on_Spike_game_over() -> void:
    game_over_node.position = player_node.position
    game_over_node.visible = true
