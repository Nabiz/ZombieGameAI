extends Area2D

var id = 0
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
				var neighbor = create_neighbor(position+Vector2(i*32,j*32))
				if neighbor:
					neighbors.append(neighbor)
					graph.add_edge(id, neighbor.id)
	return neighbors

func create_neighbor(new_vertex_position):
	if new_vertex_position.x < 0 or new_vertex_position.x > 1024 or new_vertex_position.y < 0 or new_vertex_position.y > 600:
		return
	for vertex in graph.vertecies:
		if vertex.position == new_vertex_position:
			graph.add_edge(id, vertex.id)
			return
	var new_vertex = vertex_scene.instance()
	new_vertex.position = new_vertex_position
	graph.add_vertex(new_vertex)
	return new_vertex
