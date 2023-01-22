extends Node

var graph
var bots
var team0 = []
var team1 = []

var aids = []
var bullets = []

func _ready():
	graph = get_node("../Main/Graph")
	bots = get_tree().get_nodes_in_group("bots")
	print(bots)
	for bot in bots:
		if bot.team == 0:
			team0.append(bot)
		else:
			team1.append(bot)
