extends Node2D


var radius: int = 16
var speed = 35
var angle_speed = 1
var heading = Vector2.RIGHT
var velocity = Vector2.ZERO

var laser
var is_laser = false

func _ready():
	Utils.player = self
	is_laser = false
	laser = $ColorRect
	laser.visible = is_laser

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_select"):
		is_laser = !is_laser
		laser.visible = is_laser
	
	if Input.is_action_pressed("ui_right"):
		rotation += delta * angle_speed
	elif Input.is_action_pressed("ui_left"):
		rotation -= delta * angle_speed
	
	if Input.is_action_pressed("ui_up"):
		velocity = Vector2.RIGHT.rotated(rotation) * speed
		position += velocity * delta
	elif Input.is_action_pressed("ui_down"):
		velocity = Vector2.LEFT.rotated(rotation) * speed
		position += velocity * delta
	else:
		velocity = Vector2.ZERO
	heading = Vector2.RIGHT.rotated(rotation).normalized()
	
	position.x=clamp(position.x, 20+radius, 1004-radius)
	position.y=clamp(position.y, 20+radius, 580-radius)

