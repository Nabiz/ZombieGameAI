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
		var is_checking = true
		while is_checking:
			v = Utils.graph.vertices[randi() % len(Utils.graph.vertices)]
			is_checking = false
			for bot in Utils.bots:
				if v.position.distance_squared_to(bot.position) < 10000:
					is_checking = true
		v.change_info("aid")
		if not v in Utils.aids:
			Utils.aids.append(v)

	if len(Utils.bullets) < 3:
		var v = Utils.graph.vertices[randi() % len(Utils.graph.vertices)]
		var is_checking = true
		while is_checking:
			v = Utils.graph.vertices[randi() % len(Utils.graph.vertices)]
			is_checking = false
			for bot in Utils.bots:
				if v.position.distance_squared_to(bot.position) < 10000:
					is_checking = true
		v.change_info("bullet")
		if not v in Utils.bullets:
			Utils.bullets.append(v)
