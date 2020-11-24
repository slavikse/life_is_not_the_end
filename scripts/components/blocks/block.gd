extends StaticBody2D

class_name Block

const MAX_HEALTH := 4

export(int, 4) var health := 0
export(PackedScene) var BlockDestroyScene: PackedScene

onready var animation_player_node := $AnimationPlayer as AnimationPlayer
onready var collision_shape_node := $CollisionShape2D as CollisionShape2D
onready var blocks_node := $'/root/Level/Blocks' as Node2D


func _ready() -> void:
    update_health_display()


func update_health_display() -> void:
    if health > 0 and health <= MAX_HEALTH:
        animation_player_node.play('hp%s' % health)


# external call
func increse_health() -> void:
    health += 1
    update_health_display()

    if health == MAX_HEALTH:
        swap_blocks()


func swap_blocks() -> void:
    hide()
    collision_shape_node.queue_free()

    var block_destroy_node := BlockDestroyScene.instance() as Node2D
    block_destroy_node.position = position
    blocks_node.call_deferred('add_child', block_destroy_node)

    var animation_player := block_destroy_node.get_node('AnimationPlayer') as AnimationPlayer
    animation_player.play('destroy')
    yield(animation_player, 'animation_finished')

    block_destroy_node.queue_free()
    queue_free()


# external call
func force_swap() -> void:
    health = MAX_HEALTH
    update_health_display()

    yield(get_tree().create_timer(0.2), 'timeout')
    swap_blocks()
