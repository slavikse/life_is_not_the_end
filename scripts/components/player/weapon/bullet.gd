extends RigidBody2D

class_name Bullet


func destroy() -> void:
    queue_free()


func _on_Area2D_body_entered(body: Node2D) -> void:
    if body is Block:
        (body as Block).reduce_health()
        destroy()

    elif body is Door:
        destroy()

    elif body is Candle:
        (body as Candle).ignite()
        destroy()
