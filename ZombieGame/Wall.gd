extends Node2D

class_name Wall

export var size: Vector2 = Vector2.ZERO
export var normal: Vector2 = Vector2.RIGHT

func _ready():
	Utils.walls.append(self)

func _draw():
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.2, 0.2, 0.2), true)
