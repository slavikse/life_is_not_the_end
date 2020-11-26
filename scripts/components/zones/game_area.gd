extends Area2D


func _on_GameArea_body_exited(body: Node2D) -> void:
    if body is Player:
        (body as Player).external_game_over()
        # TODO экран смерти? быстрый.
        #warning-ignore:return_value_discarded
        get_tree().reload_current_scene()

    elif body is Bullet:
        (body as Bullet).external_destroy()

    elif body is Shuriken:
        (body as Shuriken).external_destroy()
