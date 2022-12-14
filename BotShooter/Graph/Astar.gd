extends Node

class_name MyAstar

var graph
#var id_source = 0
#var id_target = 64

func search(id_source, id_target):
	graph = Utils.graph
	var distance = {}
	var previous = {}
	var heuristic = {}
	var queue = [id_source]
	for v in graph.vertices:
		distance[v.id] = 999999
		previous[v.id] = null
		heuristic[v.id] = graph.get_vertex(id_target).position.distance_squared_to(graph.get_vertex(v.id).position)
		if v.id != id_source:
			queue.append(v.id)
	distance[id_source] = 0

	if id_source == id_target:
		return previous

	while not queue.empty():
		var u_id = get_id_of_smallest_dist_in_queue(queue, distance, heuristic)
		queue.erase(u_id)
		for v_id in graph.get_vertex(u_id).get_neighbors():
			var alt = distance[u_id] + graph.get_edge(u_id, v_id).cost
			if alt < distance[v_id]:
				distance[v_id] = alt
				previous[v_id] = u_id
		if previous[id_target] != null:
			break
	return previous

func get_id_of_smallest_dist_in_queue(queue, distance, heuristic):
	var min_dist = 9999999
	var min_id = null
	for id in queue:
		var dist = distance[id] + heuristic[id]
		if dist < min_dist:
			min_dist = dist
			min_id = id
	return min_id
