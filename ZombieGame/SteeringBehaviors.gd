extends Node

class_name SteeringBehaviors

var zombie
var rng

var all_obstacles = []

func _init(new_zombie) -> void:
	rng = RandomNumberGenerator.new()
	rng.randomize()
	zombie = new_zombie
	
	var children = zombie.get_parent().get_children()
	for child in children:
		if child.is_in_group("Obstacle"):
			all_obstacles.append(child)

func calculate() -> Vector2:
	var seek = seek(Vector2(400, 600))
	return seek + obstacle_avoidance(all_obstacles)

#SEEK
func seek(target_position: Vector2) -> Vector2:
	var desired_velocity: Vector2 = (target_position - zombie.position).normalized() * zombie.max_speed
	return desired_velocity - zombie.velocity

#FLEE
const panic_distance_squared: float = 100.0 * 100.0

func flee(target_position: Vector2) -> Vector2:
	if target_position.distance_squared_to(zombie.position) > panic_distance_squared:
		return Vector2.ZERO
	var desired_velocity: Vector2 = (zombie.position - target_position).normalized() * zombie.max_speed
	return desired_velocity - zombie.velocity

#ARIVE
enum Deceleration {slow = 5, normal = 2, fast = 1}
const deceleration_tweaker: float = 2.0

func arrive(target_position: Vector2, deceleration: int) -> Vector2:
	var to_target: Vector2 = target_position - zombie.position
	var distance = to_target.length()
	if distance > 0:
		var speed: float = distance / (deceleration * deceleration_tweaker)
		speed = min(speed, zombie.max_speed)
		var desired_velocity: Vector2 = to_target * speed / distance
		return desired_velocity - zombie.velocity
	return Vector2.ZERO

#PURSUIT
func pursuit(evader) -> Vector2:
	var to_evader: Vector2 = evader.position - zombie.position
	var relative_heading: float = zombie.heading.dot(evader.heading)
	if to_evader.dot(zombie.heading) > 0 and relative_heading < -0.95:
		return seek(evader.position)
	var look_ahead_time: float = to_evader.length() / (zombie.max_speed + evader.velocity.length())
	return seek(evader.position + evader.velocity * look_ahead_time)

#EVADE
func evade(pursuer) -> Vector2:
	var to_pursuer = pursuer.position - zombie.position
	var look_ahead_time = to_pursuer.length() / (zombie.max_speed + pursuer.velocity.length())
	return flee(pursuer.position + pursuer.velocity * look_ahead_time)

#WANDER
var wander_radius: float = 300
var wander_distance: float = 500
var wander_jitter: float = 200
var wander_target: Vector2 = Vector2.ZERO

func wander() -> Vector2:
	wander_target += Vector2(rng.randf_range(-1.0, 1.0) * wander_jitter, rng.randf_range(-1.0, 1.0) * wander_jitter)
	wander_target = wander_target.normalized() * wander_radius
	var target_local: Vector2 = wander_target + Vector2(wander_distance, 0)
	var target_world = target_local.rotated(zombie.rotation) + zombie.position
	return target_world - zombie.position

#OBSTACLE AVOIDANCE
var min_detection_box_length = 100

func obstacle_avoidance(obstacles) -> Vector2:
	#CLOSEST OBSTACLE DETECTION
	var detection_box_length = min_detection_box_length + (zombie.velocity.length()/zombie.max_speed) * min_detection_box_length
	#tag obstacles ????
	var closest_obstacle = null
	var dist_to_closest: float = 99999
	var local_pos_of_closest_obstacle: Vector2
	for obstacle in obstacles:
		if true: # tag obstacle
			var local_pos: Vector2 = (obstacle.position - zombie.position).rotated(-zombie.rotation)
			if local_pos.x >= 0:
				var expanded_radius: float = obstacle.radius + zombie.radius
				if abs(local_pos.y) < expanded_radius:
					var c_x: float = local_pos.x
					var c_y: float = local_pos.y
					var sqrt_part: float = sqrt(expanded_radius*expanded_radius-c_x*c_y)
					var ip = c_x - sqrt_part
					if ip <= 0:
						ip = c_x + sqrt_part
					if ip < dist_to_closest:
						closest_obstacle = obstacle
						dist_to_closest = ip
						local_pos_of_closest_obstacle = local_pos
	#CALCULATING STEERING FORCE
	var steering_force: Vector2 = Vector2.ZERO
	if closest_obstacle:
		var multiplayer: float = 1.0 + (detection_box_length - local_pos_of_closest_obstacle.x) / detection_box_length
		steering_force.y = (closest_obstacle.radius - local_pos_of_closest_obstacle.y) * multiplayer
		var breaking_weight: float = 0.2
		steering_force.x = (closest_obstacle.radius - local_pos_of_closest_obstacle.x) * breaking_weight
	return steering_force.rotated(zombie.rotation)















