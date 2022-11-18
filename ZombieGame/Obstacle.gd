extends Node2D

export var radius: int = 40

func _ready():
	Utils.obstacles.append(self)
	$Sprite.scale = Vector2(radius/32.0, radius/32.0)
	rotate(PI*randf())

#func _draw():
#	draw_circle(Vector2.ZERO, radius, Color.darkgray)
