extends Node2D


var radius: int = 16
var speed = 100
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
	if is_laser:
		set_laser_size()
		process_laser_attack()
		
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
