extends RigidBody2D

class_name Bullet


func _on_Area2D_body_entered(body: Node2D) -> void:
    if body:
        destroy()

    if body is Block:
        (body as Block).increse_health()


# external call
func destroy() -> void:
    queue_free()
