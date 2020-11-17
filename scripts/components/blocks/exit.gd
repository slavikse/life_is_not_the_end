extends Area2D


# TODO
func _on_Exit_body_entered(body: Player) -> void:
    if body:
        print('Пройдено', body)
