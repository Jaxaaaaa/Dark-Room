extends Node2D

@export var creature: PackedScene

func _on_timer_timeout() -> void:
	var c = creature.instantiate()
	get_tree().current_scene.add_child(c)
	c.global_transform = global_transform
