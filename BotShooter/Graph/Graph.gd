extends Node2D

var vertecies = []
var edges = []
var n = 1

var edge_scene = load("res://Graph/Edge.tscn")

func _ready():
	vertecies.append($Vertex)
	create_graph()
	
	yield(get_tree(), "idle_frame")
	var verticles_to_erase = []
	var edges_to_erase = []
	for v in vertecies:
		if v.get_overlapping_bodies():
			verticles_to_erase.append(v)
			v.queue_free()
			for edge in edges:
				if v.id == edge.id_from or v.id == edge.id_to:
					edges_to_erase.append(edge)
					edge.queue_free()
	
	for verticle in verticles_to_erase:
		vertecies.erase(verticle)
	for edge in edges_to_erase:
		edges.erase(edge)


func get_vertex(id):
	for vertex in vertecies:
		if vertex.id == id:
			return vertex

func add_vertex(vertex):
	vertex.id = n
	add_child(vertex)
	if vertex.get_overlapping_bodies():
		vertex.queue_free()
		return
	n += 1
	vertecies.append(vertex)

func add_edge(from, to):
	var edge = edge_scene.instance()
	edge.id_from = from
	edge.id_to = to
	edge.calculate_cost()
	add_child(edge)
	edges.append(edge)

func create_graph():
	var queue = [$Vertex]
	while not queue.empty():
		var v = queue.pop_front()
		queue.append_array(v.create_neighbors())
