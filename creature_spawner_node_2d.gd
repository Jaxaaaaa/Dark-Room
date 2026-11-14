extends Node2D

@export var creature: PackedScene
@export var floor_layer: TileMapLayer
var tiles: Array[Vector2i]
var params: PhysicsPointQueryParameters2D

func _ready() -> void:
	tiles = floor_layer.get_used_cells()
	params = PhysicsPointQueryParameters2D.new()
	params.collision_mask = 2
	
func _on_timer_timeout() -> void:
	var spawn_position = find_spawn_position()
	if spawn_position != Vector2.INF:
		var c = creature.instantiate()
		get_tree().current_scene.add_child(c)
		c.global_position = spawn_position
	
func find_spawn_position() -> Vector2:
	for _i in range(10):
		var spawn_tile = tiles.pick_random()
		var spawn_coords = floor_layer.map_to_local(spawn_tile)
		var coords_position = floor_layer.to_global(spawn_coords)
		params.position = coords_position
		if get_world_2d().direct_space_state.intersect_point(params).is_empty():
			return coords_position
	return Vector2.INF
