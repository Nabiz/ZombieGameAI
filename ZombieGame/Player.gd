extends Node2D


var radius: int = 16
var speed = 100
var angle_speed = 3
var heading = Vector2.RIGHT
var velocity = Vector2.ZERO

var laser

func _ready():
	Utils.player = self
	laser = $ColorRect

func _physics_process(delta):
	if Input.is_action_pressed("ui_right"):
		rotation += delta * angle_speed
	elif Input.is_action_pressed("ui_left"):
		rotation -= delta * angle_speed
	if Input.is_action_pressed("ui_up"):
		position += Vector2.RIGHT.rotated(rotation) * speed * delta
	elif Input.is_action_pressed("ui_down"):
		position += Vector2.LEFT.rotated(rotation) * speed * delta
	heading = Vector2.RIGHT.rotated(rotation).normalized()
	velocity = heading * speed
	
	position.x=clamp(position.x, 20+radius, 1004-radius)
	position.y=clamp(position.y, 20+radius, 580-radius)
