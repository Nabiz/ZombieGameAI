extends Node2D


var radius: int = 16
var speed = 100
var angle_speed = 1
var heading = Vector2.RIGHT
var velocity = Vector2.ZERO

var laser
var is_laser = false
var can_laser = true

func _ready():
	Utils.player = self
	laser = $ColorRect

func _physics_process(delta):
	set_laser_size()
	if is_laser:
		process_laser_attack()
	if Input.is_action_just_pressed("ui_attack") and can_laser:
		laser.color = Color.red
		can_laser = false
		is_laser = true
		$LaserGhost.start(0.25)
		$Timer.start(2)
	
#	if Input.is_action_pressed("ui_right"):
#		rotation += delta * angle_speed
#	elif Input.is_action_pressed("ui_left"):
#		rotation -= delta * angle_speed
	rotation = (get_viewport().get_mouse_position()-position).angle()
	
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

func set_laser_size():
	var result_t = 1500
	for obstacle in Utils.obstacles:
		var player_to_obstacle = obstacle.position - position
		var radius_squared = obstacle.radius * obstacle.radius
		var player_to_obstacle_length_squared = player_to_obstacle.length_squared()

		var a = player_to_obstacle.dot(heading)
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
	for zombie in Utils.zombies:
		var player_to_obstacle = zombie.position - position
		var radius_squared = zombie.radius * zombie.radius
		var player_to_obstacle_length_squared = player_to_obstacle.length_squared()
		
		#var a = player_to_obstacle.dot(heading)
		var a = player_to_obstacle.dot(heading)
		var b_sq = player_to_obstacle_length_squared - a*a
		if radius_squared - b_sq < 0:
			continue
		var f = sqrt(radius_squared - b_sq)
		var t = 1500
		if player_to_obstacle_length_squared > radius_squared:
			t = a - f
		if t > 0 and t < laser.rect_size.x:
			Utils.zombies.erase(zombie)
			Utils.main.container_of_entities.erase(zombie)
			Utils.main.movable_entities.erase(zombie)
			zombie.queue_free()


func _on_Timer_timeout():
	can_laser = true


func _on_LaserGhost_timeout():
	laser.color = Color.white
	is_laser = false
