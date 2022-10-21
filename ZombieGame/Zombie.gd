extends Node2D


var radius: int
var velocity: Vector2
var steering: SteeringBehaviors
var max_speed: float

func _ready() -> void:
	max_speed = 100
	radius = 10
	steering = SteeringBehaviors.new(self)

func _physics_process(delta) -> void:
	velocity += steering.calculate() * delta
	velocity = velocity.limit_length(max_speed)
	position += velocity * delta

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, Color.red)
