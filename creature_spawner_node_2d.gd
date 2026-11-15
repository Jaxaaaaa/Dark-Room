extends Node2D

@export var creature: PackedScene
@export var floor_layer: TileMapLayer
@export var min_distance: float
## x = how much the room is full, y = spawn intensity
@export var spawn_curve: Curve 
##how many creatures needed in a room to consider it as full
@export var max_creatures: int 
##increase it to increase the average spawn interval
@export var max_delay: float 
##reduce it to reduce the average spawn interval
@export var min_delay: float 

const MAX_SPAWN_TRY =  10
var tiles: Array[Vector2i]
var params: PhysicsPointQueryParameters2D
var player: Player

func _ready() -> void:
	tiles = floor_layer.get_used_cells()
	params = PhysicsPointQueryParameters2D.new() #Create a parameter card
	params.collision_mask = 2 #2 = walls
	player = get_tree().get_first_node_in_group("Player_group")
func _on_timer_timeout() -> void:
	var creature_count = get_tree().get_nodes_in_group("Creatures").size()
	var creature_ratio = clamp(float(creature_count) / max_creatures, 0.0, 1.0) #0 the room is empty, 1 the room is full
	var curve_intensity = spawn_curve.sample(creature_ratio)
	var delay = lerp(max_delay, min_delay, curve_intensity) #0 intensity = longer spawn delay, 1 intensity = shorter spawn delay
	$Timer.wait_time = delay
	print(creature_ratio)
	print(delay)
	print(get_tree().get_nodes_in_group("Creatures"))
	var spawn_position = find_spawn_position()
	if spawn_position != Vector2.INF: 
		var c = creature.instantiate()
		get_tree().current_scene.add_child(c)
		c.global_position = spawn_position
	
func find_spawn_position() -> Vector2:
	for _i in range(MAX_SPAWN_TRY):
		var spawn_tile = tiles.pick_random()
		var spawn_coords = floor_layer.map_to_local(spawn_tile)
		var coords_position = floor_layer.to_global(spawn_coords)
		params.position = coords_position #give the tested position to the parameter card
		var distance_to_player = coords_position.distance_to(player.global_position)
		#check if the position in the parameter card is free and far from the player
		if distance_to_player > min_distance and get_world_2d().direct_space_state.intersect_point(params).is_empty():
			return coords_position
	return Vector2.INF #no space found 
