extends Node2D

var container_of_entities = []
var movable_entities = []

var zombie_groups = []

func _ready():
	Utils.main = self
	container_of_entities += Utils.zombies + Utils.obstacles
	container_of_entities.append(Utils.player)
	movable_entities += Utils.zombies
	movable_entities.append(Utils.player)

func _physics_process(delta):
	for entity in movable_entities:
		enforce_non_penetration_constraint(entity)

func  create_zombie_group():
	if Utils.zombies.size() > 0:
		var random_zombie = Utils.zombies[randi() % Utils.zombies.size()]
		random_zombie.tag_neighbors(100)
		
		var zombie_count = 0
		var zombie_group = [random_zombie]
		for zombie in Utils.zombies:
			if zombie.tagged and zombie_count < 5:
				zombie_count += 1
				zombie_group.append(zombie)
		zombie_groups.append(zombie_group)

func reapet_gruping():
	create_zombie_group()
	for group in zombie_groups:
		for z in group:
			if is_instance_valid(z):
				z.state = "pursuit"
				z.max_speed = 100
		zombie_groups.erase(group)

func enforce_non_penetration_constraint(entity):
	for current_entity in container_of_entities:
		if entity != current_entity:
			var to_entity: Vector2 = entity.position - current_entity.position
			var dist_from_each_oder: float = to_entity.length()
			var amout_of_overlap = entity.radius + current_entity.radius - dist_from_each_oder
			if amout_of_overlap >= 0:
				entity.position += (to_entity/dist_from_each_oder) * amout_of_overlap


func _on_Timer_timeout():
	reapet_gruping()
