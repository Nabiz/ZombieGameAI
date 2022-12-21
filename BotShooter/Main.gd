extends Node2D

var astar
var bot
var flag = true
var source = 1
var target = 1

func _ready():
	astar = MyAstar.new()
	bot = $Bot
	

func _process(delta):
	var x
	if flag:
		flag = false
		x = astar.search(source, target)
		var safe_target = target
		#print(x)
		#print(target)
		bot.position = Utils.graph.get_vertex(target).position
		while target:
			safe_target = target
			bot.position = Utils.graph.get_vertex(target).position
			target = x[target]
			#print(target)
			yield(get_tree().create_timer(0.2), "timeout")
		
		source = Utils.graph.vertices[randi() % len(Utils.graph.vertices)].id
		target = safe_target
		#prints("NOWY CEL", source)
		#prints("TARGET", target)
		flag = true
