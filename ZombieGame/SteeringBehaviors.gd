extends Node

class_name SteeringBehaviors

var zombie
var rng

func _init(new_zombie) -> void:
	rng = RandomNumberGenerator.new()
	rng.randomize()
	zombie = new_zombie

func calculate() -> Vector2:
	return wander()

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

