extends Area2D

var id = 1
var vertex_scene = load("res://Graph/Vertex.tscn")
var graph

func _ready():
	graph = get_parent()
	$Label.text = str(id)

func create_neighbors():
	var neighbors = []
	for i in range(-1, 2):
		for j in range(-1, 2):
			if not (i == 0 and j == 0):
				var neighbor = create_neighbor(position+Vector2(i*64,j*64))
				if neighbor:
					neighbors.append(neighbor)
					graph.add_edge(id, neighbor.id)
	return neighbors

func create_neighbor(new_vertex_position):
	if new_vertex_position.x < 0 or new_vertex_position.x > 1024 or new_vertex_position.y < 0 or new_vertex_position.y > 600:
		return
	for vertex in graph.vertices:
		if vertex.position == new_vertex_position:
			graph.add_edge(id, vertex.id)
			return
	var new_vertex = vertex_scene.instance()
	new_vertex.position = new_vertex_position
	graph.add_vertex(new_vertex)
	return new_vertex

func get_neighbors():
	var neighbors = []
	for edge in graph.edges:
		if edge.id_from == id:
			neighbors.append(edge.id_to)
	return neighbors
