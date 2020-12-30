extends StaticBody2D

class_name Block

export(int, 4) var health := 0
export(PackedScene) var BlockDestroyScene: PackedScene

const MAX_HEALTH := 4

onready var blocks_node := get_parent() as Node2D
onready var health_animation_node := $Health as AnimationPlayer
onready var collision_node := $Collision as CollisionPolygon2D
onready var increase_health_audio_node := $IncreseHealth as AudioStreamPlayer2D
onready var swap_blocks_audio_node := $SwapBlocks as AudioStreamPlayer2D


func _ready() -> void:
    update_health_display()


func update_health_display() -> void:
    if health > 0 and health <= MAX_HEALTH:
        health_animation_node.play('hp%s' % health)


func external_increse_health() -> void:
    health += 1
    update_health_display()
    increase_health_audio_node.play()

    if health == MAX_HEALTH:
        swap_blocks()


func swap_blocks() -> void:
    hide()
    collision_node.queue_free()

    var block_destroy_node := BlockDestroyScene.instance() as Node2D
    block_destroy_node.position = position
    blocks_node.call_deferred('add_child', block_destroy_node)

    var destroy_animation_node := block_destroy_node.get_node('Destroy') as AnimationPlayer
    destroy_animation_node.play('destroy')
    swap_blocks_audio_node.play()
    yield(destroy_animation_node, 'animation_finished')

    block_destroy_node.queue_free()
    queue_free()
