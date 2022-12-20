extends Node2D

var id_from
var id_to
var cost

func _ready():
	pass

func _draw():
	var start = Utils.graph.get_vertex(id_from).position
	var vector = Utils.graph.get_vertex(id_to).position
	draw_line(start, vector, Color.green, 2)
