extends Node2D


var radius: int
var velocity: Vector2
var heading: Vector2
var side: Vector2
var steering: SteeringBehaviors
var max_speed: float

var tagged: bool =  false
var state = "wander"

func _ready() -> void:
	Utils.zombies.append(self)
	max_speed = 40
	radius = 10
	steering = SteeringBehaviors.new(self)
	heading = Vector2.RIGHT
	side = heading.rotated(PI/2)
	state = "wander"

func _physics_process(delta) -> void:
	state = calculate_state()
	velocity += steering.calculate(state) * delta
	velocity = velocity.clamped(max_speed)
	position += velocity * delta
	if velocity.length_squared() > 50:
		heading = velocity.normalized()
		side = heading.rotated(PI/2)
		rotation = heading.angle()
	
	position.x=clamp(position.x, 20+radius, 1004-radius)
	position.y=clamp(position.y, 20+radius, 580-radius)

func calculate_state():
	if (position - Utils.player.position).length_squared() < 40000:
		return "pursuit"
	if Utils.player.is_laser:
		return "hide"
	if (position - Utils.player.position).length_squared() > 90000 or state=="hide":
		return "wander"
	return state

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, Color.darkred)
	draw_circle(radius*Vector2.RIGHT, 5, Color.darkred)

func tag_neighbors(radius: float):
	for zombie in Utils.zombies:
		zombie.tagged = false
		var to: Vector2 = zombie.position - position
		var range_radius = radius + zombie.radius
		if zombie != self and to.length_squared() < range_radius * range_radius:
			zombie.tagged = true
