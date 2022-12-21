extends Node2D

var id_from
var id_to
var cost

func calculate_cost():
	var start = Utils.graph.get_vertex(id_from).position
	var end = Utils.graph.get_vertex(id_to).position
	cost = (end-start).length()

func _draw():
	var start = Utils.graph.get_vertex(id_from).position
	var end = Utils.graph.get_vertex(id_to).position
	var vector = (end - start).normalized()
	draw_line(start, end, Color.green, 1)
	draw_circle(end - 5*vector, 2, Color.green)
