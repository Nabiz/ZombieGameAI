extends Node2D


var radius: int
var velocity: Vector2
var heading: Vector2
var side: Vector2
var steering: SteeringBehaviors
var max_speed: float

export var state = "seek"

func _ready() -> void:
	max_speed = 50
	radius = 10
	steering = SteeringBehaviors.new(self)
	heading = Vector2.RIGHT
	side = heading.rotated(PI/2)

func _physics_process(delta) -> void:
	match state:
		"seek":
			velocity += steering.calculate() * delta
		"pursuit":
			velocity += steering.pursuit(get_parent().get_node("Zombie2")) * delta
		"evade":
			velocity += steering.evade(get_parent().get_node("Zombie3")) * delta
		
	velocity = velocity.clamped(max_speed)
	position += velocity * delta
	if velocity.length_squared() > 50:
		heading = velocity.normalized()
		side = heading.rotated(PI/2)
		rotation = heading.angle()

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, Color.darkred)
	draw_circle(radius*Vector2.RIGHT, 5, Color.darkred)
