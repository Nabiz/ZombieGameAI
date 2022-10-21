extends Node2D

export var radius: int

func _draw():
	draw_circle(Vector2.ZERO, radius, Color.darkgray)
