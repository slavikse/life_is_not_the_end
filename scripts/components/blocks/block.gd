extends StaticBody2D

class_name Block

export(int, 4) var health := 4
export(bool) var is_invulnerable := false
export(PackedScene) var BlockDestroyScene: PackedScene

onready var blocks_node := $'/root/Level/Blocks' as Node2D
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
        swap_blocks_and_destroing()


func swap_blocks_and_destroing() -> void:
    hide()

    var block_destroy_node := BlockDestroyScene.instance() as Node2D
    block_destroy_node.position = position
    blocks_node.call_deferred('add_child', block_destroy_node)

    var animation_player := block_destroy_node.get_node('AnimationPlayer') as AnimationPlayer
    animation_player.play('destroy')
    yield(animation_player, 'animation_finished')

    queue_free()
    block_destroy_node.queue_free()


func force_destroy() -> void:
    health = 0

    update_health_display()
    swap_blocks_and_destroing()
