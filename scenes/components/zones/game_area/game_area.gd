extends Area2D


func _on_GameArea_body_exited(body: Node2D) -> void:
    if body is Bullet:
        (body as Bullet).external_destroy()

    elif body is Player:
        (body as Player).external_game_over()

    elif body is Shuriken:
        (body as Shuriken).external_destroy()
