extends Node2D


var radius: int = 16
var speed = 60
var angle_speed = 1
var heading = Vector2.RIGHT
var velocity = Vector2.ZERO
var to_mouse

var laser
var is_laser = false
var can_laser = true

func _ready():
	Utils.player = self
	laser = $ColorRect

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_attack") and can_laser:
		laser.visible = true
		can_laser = false
		is_laser = true
		$LaserGhost.start(0.2)
		$Timer.start(1)
		set_laser_size()
		process_laser_attack()
	
#	if Input.is_action_pressed("ui_right"):
#		velocity = Vector2.DOWN.rotated(rotation) * speed
#	elif Input.is_action_pressed("ui_left"):
#		velocity = Vector2.UP.rotated(rotation) * speed
#	else:
#		velocity = Vector2.ZERO
#
#	if Input.is_action_pressed("ui_up"):
#		velocity = (velocity/speed + Vector2.RIGHT.rotated(rotation)).normalized() * speed
#	elif Input.is_action_pressed("ui_down"):
#		velocity = (velocity/speed + Vector2.LEFT.rotated(rotation)).normalized() * speed
	var v = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		v += Vector2.RIGHT
	if Input.is_action_pressed("ui_left"):
		v += Vector2.LEFT
	if Input.is_action_pressed("ui_up"):
		v += Vector2.UP
	elif Input.is_action_pressed("ui_down"):
		v += Vector2.DOWN
	velocity = v.normalized() * speed
	position += velocity * delta
	rotation = (get_viewport().get_mouse_position()-position).angle()
	heading = velocity.normalized()
	to_mouse = (get_viewport().get_mouse_position() - position).normalized()
	
	position.x=clamp(position.x, 20+radius, 1004-radius)
	position.y=clamp(position.y, 20+radius, 580-radius)

func set_laser_size():
	var result_t = 1500
	for obstacle in Utils.obstacles:
		var player_to_obstacle = obstacle.position - position
		var radius_squared = obstacle.radius * obstacle.radius
		var player_to_obstacle_length_squared = player_to_obstacle.length_squared()

		var a = player_to_obstacle.dot(to_mouse)
		var b_sq = player_to_obstacle_length_squared - a*a
		if radius_squared - b_sq < 0:
			continue
		var f = sqrt(radius_squared - b_sq)
		var t = 1500
		if player_to_obstacle_length_squared > radius_squared:
			t = a - f
		if t > 0 and result_t > t:
			result_t = t
	laser.rect_size.x = result_t

func process_laser_attack():
	var min_t = 1500
	var zombie_to_kill = null
	for zombie in Utils.zombies:
		var player_to_obstacle = zombie.position - position
		var radius_squared = zombie.radius * zombie.radius
		var player_to_obstacle_length_squared = player_to_obstacle.length_squared()
		
		var a = player_to_obstacle.dot(to_mouse)
		var b_sq = player_to_obstacle_length_squared - a*a
		if radius_squared - b_sq < 0:
			continue
		var f = sqrt(radius_squared - b_sq)
		var t = 1500
		if player_to_obstacle_length_squared > radius_squared:
			t = a - f
		if t > 0 and t < laser.rect_size.x and min_t > t:
			min_t = t
			zombie_to_kill = zombie
	if zombie_to_kill:
		if min_t < laser.rect_size.x:
			laser.rect_size.x = min_t
		Utils.zombies.erase(zombie_to_kill)
		Utils.main.container_of_entities.erase(zombie_to_kill)
		Utils.main.movable_entities.erase(zombie_to_kill)
		zombie_to_kill.queue_free()


func _on_Timer_timeout():
	can_laser = true


func _on_LaserGhost_timeout():
	laser.visible = false
	is_laser = false
