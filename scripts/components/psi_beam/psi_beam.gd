extends Node2D

class_name PsiBeam

export(PackedScene) var PsiBulletScene: PackedScene

onready var root_node := $'/root' as Viewport


func play(animation_move_node: AnimationPlayer, sprite_node: Sprite, player_center: Vector2) -> void:
    var is_idle := animation_move_node.current_animation == 'idle'
    var is_corner := animation_move_node.current_animation == 'corner'
    var is_horizontal := animation_move_node.current_animation == 'horizontal'
    var is_vertical := animation_move_node.current_animation == 'vertical'

    var is_left := sprite_node.flip_h
    var is_bottom := sprite_node.flip_v

    # Стороны в градусах: idle (-1), N (0), NE (45), E (90), SE (135), S (180), SW (225), W (270), NW (315).
    var rotation_degrees := -1
    var acceleration_vector := Vector2()

    if is_idle:
        rotation_degrees = -1

    else:
        if is_corner:
            if is_left and is_bottom:
                rotation_degrees = 225
                acceleration_vector = Vector2(-1, 1)

            elif is_left and not is_bottom:
                rotation_degrees = 315
                acceleration_vector = Vector2(-1, -1)

            elif not is_left and is_bottom:
                rotation_degrees = 135
                acceleration_vector = Vector2(1, 1)

            elif not is_left and not is_bottom:
                rotation_degrees = 45
                acceleration_vector = Vector2(1, -1)

        elif is_horizontal:
            if is_left:
                rotation_degrees = 270
                acceleration_vector = Vector2(-1, 0)

            else:
                rotation_degrees = 90
                acceleration_vector = Vector2(1, 0)

        elif is_vertical:
            if is_bottom:
                rotation_degrees = 180
                acceleration_vector = Vector2(0, 1)

            else:
                rotation_degrees = 0
                acceleration_vector = Vector2(0, -1)

    set_rotation_degrees(rotation_degrees)

    if can_show(rotation_degrees):
        must_be_called(player_center, acceleration_vector)


func can_show(rotation_degrees: int) -> bool:
    if rotation_degrees == -1:
        hide()
        return false

    show()
    return true


# TODO пуля будет разрушаться об препядствие
# TODO скрипт внутри пули, чтобы ее уничтожить через некоторое время.
func must_be_called(player_center: Vector2, acceleration_vector: Vector2) -> void:
    if Input.is_action_just_released('ui_psi_beam_shot'):
        var psi_bullet_node := PsiBulletScene.instance() as RigidBody2D
        psi_bullet_node.position = player_center
        psi_bullet_node.set_linear_velocity(acceleration_vector * Vector2(1000, 1000))

        root_node.add_child(psi_bullet_node)
