extends StaticBody2D

class_name Candle

onready var wick_node := $Wick as Polygon2D


# TODO открыть выход с уровня
func ignite() -> void:
    wick_node.show()
