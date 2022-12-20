extends Node2D

var vertexes = []
var edges = []
var n = 1

func _ready():
	vertexes.append($Vertex)
	create_graph()

func add_vertex(vertex):
	vertex.index = n
	add_child(vertex)
	n += 1
	vertexes.append(vertex)

func create_graph():
	var queue = [$Vertex]
	#while not queue.empty():
	for i in range(200):
		var v = queue.pop_front()
		queue.append_array(v.create_neighbors())
