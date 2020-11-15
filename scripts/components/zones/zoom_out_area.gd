extends Area2D


func _on_IsCanZoomOut_body_entered(player_node: Player) -> void:
    if player_node:
        player_node.zoom_out(false)


func _on_IsCanZoomOut_body_exited(player_node: Player) -> void:
    if player_node:
        player_node.zoom_out(true)
