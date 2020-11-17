extends StaticBody2D

class_name Block

export(int, 4) var health := 4
export(bool) var is_invulnerable := false

onready var hp_node := $HP as Node2D
onready var invulnerable_node := $Invulnerable as Polygon2D

onready var children_count := hp_node.get_child_count()
onready var children := hp_node.get_children()


func _ready() -> void:
    update_health_display()

    if is_invulnerable:
        invulnerable_node.show()


func update_health_display() -> void:
    for index in children_count:
        if index < health:
            children[index].show()

        else:
            children[index].hide()


func reduce_health() -> void:
    if is_invulnerable:
        return

    health -= 1

    if health > 0:
        update_health_display()

    else:
        queue_free()
