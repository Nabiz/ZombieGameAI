extends Node2D

var astar
var bot
var flag = true
var source = 1
var target = 1

func _ready():
	randomize()
	Utils.blue_score = $BlueScore
	Utils.red_score = $RedScore

func _process(delta):
	if len(Utils.aids) < 3:
		var v = Utils.graph.vertices[randi() % len(Utils.graph.vertices)]
		v.change_info("aid")
		if not v in Utils.aids:
			Utils.aids.append(v)
	if len(Utils.bullets) < 3:
		var v2 = Utils.graph.vertices[randi() % len(Utils.graph.vertices)]
		v2.change_info("bullet")
		if not v2 in Utils.bullets:
			Utils.bullets.append(v2)
