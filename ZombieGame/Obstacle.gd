extends Node2D

export var radius: int

func _ready():
	Utils.obstacles.append(self)

func _draw():
	draw_circle(Vector2.ZERO, radius, Color.darkgray)
