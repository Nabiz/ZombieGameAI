extends Node

class_name SteeringBehaviors

var zombie

func _init(new_zombie) -> void:
	zombie = new_zombie
	
func calculate() -> Vector2:
	return arrive(Vector2(800, 500), Deceleration.normal)


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
func arrive(target_position: Vector2, deceleration: int):
	var vec_to_target: Vector2 = target_position - zombie.position
	var distance = vec_to_target.length()
	if distance > 0:
		var speed: float = distance / (deceleration * deceleration_tweaker)
		speed = min(speed, zombie.max_speed)
		var desired_velocity: Vector2 = vec_to_target * speed / distance
		return desired_velocity - zombie.velocity
	return Vector2.ZERO
