extends Node2D

var astar
var bot
var flag = true
var source = 1
var target = 1

func _ready():
	astar = MyAstar.new()
