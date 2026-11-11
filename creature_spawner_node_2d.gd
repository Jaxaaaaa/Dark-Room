extends Node2D

@export var creature: PackedScene
@export var floor_layer: TileMapLayer
var tiles


func _ready() -> void:
	tiles = floor_layer.get_used_cells()
	
func _on_timer_timeout() -> void:
	var c = creature.instantiate()
	var spawn_tile = tiles.pick_random()
	var spawn_coords = floor_layer.map_to_local(spawn_tile)
	get_tree().current_scene.add_child(c)
	c.global_position = floor_layer.to_global(spawn_coords)
