extends Area2D

class_name LightZone

@export var light: Light2D


func get_intensity_at(_pos: Vector2) -> float:
	return light.energy
