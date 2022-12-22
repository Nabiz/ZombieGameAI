extends Node2D

var astar
var bot
var flag = true
var source = 1
var target = 1

func _ready():
	randomize()

func _on_AidTimer_timeout():
	var v = Utils.graph.vertices[randi() % len(Utils.graph.vertices)]
	if v.info == "empty":
		if randi() % 2 == 0:
			v.change_info("aid")
		else:
			v.change_info("bullet")
	$AidTimer.start(4)
