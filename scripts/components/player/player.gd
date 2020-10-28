extends KinematicBody2D

var shape := preload('./shape.gd').new()
var move := preload('./move.gd').new()
var jump := preload('./jump.gd').new()

const FLOOR := Vector2.UP
var velocity := Vector2.ZERO;

# enabled | disabled
var zoom_out_status := 'enabled'
var is_game_over := false

onready var sprite_node := $Sprite as Sprite


#warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
    if is_game_over:
        return

    if zoom_out_status == 'enabled':
        scale = shape.transform(scale)

    moving()
    jumping()
    sprite_flip()

    velocity = move_and_slide(velocity, FLOOR)


func moving() -> void:
    velocity.x = move.moving(velocity.x, shape.is_normal_shape)

    if is_on_wall():
        velocity.x = 0


func jumping() -> void:
    if is_on_floor():
        velocity.y = jump.jumping(velocity.y, shape.is_normal_shape)

    if is_on_ceiling():
        velocity.y = jump.ceiling(velocity.y, shape.is_normal_shape)

    velocity.y = jump.continuous_jumping(velocity.y, shape.is_normal_shape)


# TODO advance(0) - для быстрой смены стороны в анимации при развороте
func sprite_flip() -> void:
    if velocity.x != 0:
        sprite_node.flip_h = velocity.x < 0


func _on_ZoomOutArea_zoom_out(status: String) -> void:
    zoom_out_status = status


func _on_Spike_game_over() -> void:
    game_over()


func game_over() -> void:
    is_game_over = true

    # TODO анимация гибели и после окончания перезагрузить сцену
    yield(get_tree().create_timer(1), 'timeout')
    #warning-ignore:return_value_discarded
    get_tree().reload_current_scene()
