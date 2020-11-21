extends StaticBody2D

class_name Block

export(int, 4) var health := 4
export(bool) var is_invulnerable := false

onready var hp_node := $HP as Node2D
onready var protection_node := $Protection as Sprite

onready var hp_children_count := hp_node.get_child_count()
onready var hp_children := hp_node.get_children()


func _ready() -> void:
    update_health_display()

    if is_invulnerable:
        protection_node.show()


func update_health_display() -> void:
    for index in hp_children_count:
        if index < health:
            hp_children[index].show()

        else:
            hp_children[index].hide()


func reduce_health() -> void:
    if is_invulnerable:
        return

    health -= 1

    if health > 0:
        update_health_display()

    else:
        queue_free()
