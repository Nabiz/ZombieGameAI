extends Node2D

var container_of_entities = []
var movable_entities = []

func _ready():
	Utils.main = self
	container_of_entities += Utils.zombies + Utils.obstacles
	container_of_entities.append(Utils.player)
	movable_entities += Utils.zombies
	movable_entities.append(Utils.player) 

func _physics_process(delta):
	for entity in movable_entities:
		enforce_non_penetration_constraint(entity)

func enforce_non_penetration_constraint(entity):
	for current_entity in container_of_entities:
		if entity != current_entity:
			var to_entity: Vector2 = entity.position - current_entity.position
			var dist_from_each_oder: float = to_entity.length()
			var amout_of_overlap = entity.radius + current_entity.radius - dist_from_each_oder
			if amout_of_overlap >= 0:
				entity.position += (to_entity/dist_from_each_oder) * amout_of_overlap
