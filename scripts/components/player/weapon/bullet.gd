extends RigidBody2D

class_name Bullet


func destroy() -> void:
    queue_free()
