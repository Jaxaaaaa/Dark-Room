extends Area2D

class_name LightZone

@export var light: Light2D
@export var light_range: float

func get_intensity_at(pos: Vector2) -> float:
	var distance_to_source = pos.distance_to(light.global_position)
	var ratio = clamp(distance_to_source / light_range, 0.0, 1.0)
	var intensity = lerp(light.energy, 0.0, ratio)
	return intensity
