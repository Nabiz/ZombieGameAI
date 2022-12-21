extends Node2D

var astar

func _ready():
	astar = MyAstar.new()
	

func _process(delta):
	var x
	var target = 65
	if Input.is_action_just_pressed("ui_select"):
		x = astar.search(0, 65)
		print(x)
		print(target)
		while target:
			target = x[target]
			print(target)
			
