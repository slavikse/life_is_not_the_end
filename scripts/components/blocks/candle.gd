extends StaticBody2D

class_name Candle

onready var wick_node := $Wick as Polygon2D
onready var door_node := $'/root/Level/World/ClosedRoom/Door' as Door

var is_not_triggered := true


func ignite() -> void:
    if is_not_triggered:
        is_not_triggered = false

        wick_node.show()
        door_node.open()
