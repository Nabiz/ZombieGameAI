extends Node2D

var vertecies = []
var edges = []
var n = 1

var edge_scene = load("res://Graph/Edge.tscn")

func _ready():
	vertecies.append($Vertex)
	create_graph()

func get_vertex(id):
	for vertex in vertecies:
		if vertex.id == id:
			return vertex

func add_vertex(vertex):
	vertex.id = n
	add_child(vertex)
	n += 1
	vertecies.append(vertex)

func add_edge(from, to):
	var edge = edge_scene.instance()
	edge.id_from = from
	edge.id_to = to
	add_child(edge)
	edges.append(edge)

func create_graph():
	var queue = [$Vertex]
	while not queue.empty():
		var v = queue.pop_front()
		queue.append_array(v.create_neighbors())
