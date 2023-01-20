extends KinematicBody2D

var astar
var health = 10
var health_bar
var ammo = 5
var ammo_label

var vertex = null
var destination = null
var destination_id = null

var speed = 35
var path = []
var direction

var can_shoot = false

export var team = 0

var raycast
var shoot_ray

#AID AMMO FIGHT WANDER
var state = "wander"
var goal = null

func _ready():
	astar = MyAstar.new()
	health_bar = $ProgressBar
	health_bar.value = health
	ammo_label = $Label
	ammo_label.text = str(ammo)
	raycast = $RayCast2D
	shoot_ray = $ShootRay
	if team == 0:
		shoot_ray.modulate = Color.blue
	else:
		shoot_ray.modulate = Color.red

func initialize():
	vertex = Utils.graph.vertices[randi() % len(Utils.graph.vertices)].id
	position = Utils.graph.get_vertex(vertex).position

func update_state():
	if health <= 3:
		if state == "wander":
			path = []
		state = "aid"
	elif ammo <= 3:
		if state == "wander":
			path = []
		state = "bullet"
	else:
		state = "wander"
	
	if state != "wander":
		if goal.info == "empty":
			path = []

func calculate_goal():
	if state == "aid":
		for v in Utils.graph.vertices:
			if v.info == "aid":
				print("LECZONKO")
				return v
	elif state == "bullet":
		for v in Utils.graph.vertices:
			if v.info == "bullet":
				print("DUPCIA")
				return v
	elif state == "wander":
		return Utils.graph.vertices[randi() % len(Utils.graph.vertices)]
	return Utils.graph.vertices[randi() % len(Utils.graph.vertices)]

func _process(delta):
	update_state()
	if vertex == null:
		initialize()
	if destination:
		if position.distance_to(destination) < 4:
			#position = destination
			vertex = destination_id
			
			check_pickup()
			
			destination_id = null
			destination = null
		else:
			position += delta * speed * direction
	else:
		if path:
			destination_id = path.pop_front()
			destination = Utils.graph.get_vertex(destination_id).position
			direction = (destination - position).normalized()
		else:
			goal = calculate_goal()
			search_for_new_path(goal.id)
	
	if health == 0:
		$CollisionShape2D.disabled = true
		visible = false
		set_process(false)
	
	raycast_enemy()

func search_for_new_path(target):
	if target:
		var astar_result = astar.search(vertex, target) 
		var v = astar_result[target]
		path = [target]
		while v != null:
			path.push_front(v)
			v = astar_result[v]

func check_pickup():
	var v = Utils.graph.get_vertex(vertex)
	if v.info == "aid":
		v.change_info("empty")
		health = 10
		health_bar.value = health
	elif v.info == "bullet":
		v.change_info("empty")
		ammo = clamp(ammo+5, 0, 10)
		ammo_label.text = str(ammo)

func raycast_enemy():
	var enemies
	if team == 0:
		enemies = Utils.team1
	else:
		enemies = Utils.team0
	for enemy in enemies:
		raycast.set_cast_to(enemy.position-self.position)
		raycast.force_raycast_update()
		if raycast.get_collider() == enemy:
			shoot_to_enemy(enemy, enemies)

func shoot_to_enemy(enemy, enemies):
	if can_shoot and ammo>0:
		ammo -= 1
		ammo_label.text = str(ammo)
		can_shoot = false
		shoot_ray.set_cast_to(100*(enemy.position-self.position).rotated(rand_range(-0.2, 0.2)))
		shoot_ray.force_raycast_update()
		var shoot_object = shoot_ray.get_collider()
		if shoot_object in enemies:
			enemy.health = clamp(enemy.health - 1 - randi() % 4, 0, 10)
			enemy.health_bar.value = enemy.health
		shoot_ray.set_cast_to(shoot_ray.get_collision_point()-self.position)
		shoot_ray.visible = true
		yield(get_tree().create_timer(0.2), "timeout")
		shoot_ray.visible = false
	else:
		if $ShootTimer.is_stopped():
			$ShootTimer.start(rand_range(1, 2.5))

func _draw():
	if team == 0:
		draw_circle(Vector2.ZERO, 16, Color.blue)
	else:
		draw_circle(Vector2.ZERO, 16, Color.red)


func _on_ShootTimer_timeout():
	can_shoot = true
