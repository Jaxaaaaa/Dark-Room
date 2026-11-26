extends Area2D
class_name Corridor

var max_intensity: float = 0.0
var actual_intensity: float = 0.0
var light_ratio: float = 0.0

func _ready() -> void:
	await get_tree().physics_frame
	await get_tree().physics_frame
	var calculing_intensity: float = 0.0
	for area in get_overlapping_areas():
		if area is LightZone and not area.show_creature:
			calculing_intensity += area.light.energy 
	max_intensity = calculing_intensity
	print("max = ", max_intensity)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	actual_intensity = 0.0
	for area in get_overlapping_areas():
		if area is LightZone and not area.show_creature:
			actual_intensity += area.light.energy 
	light_ratio = clamp(actual_intensity / max_intensity, 0.0, 1.0)
	
