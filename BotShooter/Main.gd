extends Node2D

var astar
var bot
var flag = true
var source = 1
var target = 1

func _ready():
	randomize()
	for i in range(2):
		var v = Utils.graph.vertices[randi() % len(Utils.graph.vertices)]
		var v2 = Utils.graph.vertices[randi() % len(Utils.graph.vertices)]
		v.change_info("aid")
		v2.change_info("bullet")

func _on_AidTimer_timeout():
	var v = Utils.graph.vertices[randi() % len(Utils.graph.vertices)]
	var v2 = Utils.graph.vertices[randi() % len(Utils.graph.vertices)]
	v.change_info("aid")
	v2.change_info("bullet")
	$AidTimer.start(20)
