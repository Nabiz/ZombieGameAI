extends Node2D

var astar
var health
var ammo

var vertex = null
var destination = null
var destination_id = null

var speed = 25
var path = []
var direction

export var team = 0

func _ready():
	astar = MyAstar.new()

func initialize():
	vertex = Utils.graph.vertices[randi() % len(Utils.graph.vertices)].id
	position = Utils.graph.get_vertex(vertex).position

func _process(delta):
	if vertex == null:
		initialize()
	if destination:
		if position.distance_to(destination) < 2:
			position = destination
			vertex = destination_id
			destination_id = null
			destination = null
		else:
			position += delta * speed * direction
	else:
		if path:
			destination_id = path.pop_front()
			destination = Utils.graph.get_vertex(destination_id).position
			direction = (destination - position).normalized()
		else:
			search_for_new_path(Utils.graph.vertices[randi() % len(Utils.graph.vertices)].id)

func search_for_new_path(target):
	var astar_result = astar.search(vertex, target) 
	var v = astar_result[target]
	path = []
	while v != null:
		path.push_front(v)
		v = astar_result[v]

func _draw():
	if team == 0:
		draw_circle(Vector2.ZERO, 16, Color.blue)
	else:
		draw_circle(Vector2.ZERO, 16, Color.red)
