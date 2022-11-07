extends Node2D


var radius: int = 16
var speed = 200
var angle_speed = 3

var laser

func _ready():
	#velocity = Vector2.ZERO
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
