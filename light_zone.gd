extends Area2D

class_name LightZone

const FLICKER_THRESHOLD = 0.95
const MAX_FLICKER_CHANCE = 0.1
const FLICKER_MIN_DURATION = 0.05
const FLICKER_MAX_DURATION = 0.15
const MIN_BRIGHTNESS = 0.7

@export var light: Light2D
@export var wall_light: Light2D
@export var light_range: float
@export var show_creature: bool
@export var power_drop_rate: float
var power: float = 1.0
var floor_light_energy: float
var wall_light_energy: float
var flicker_time_left:float

func _ready() -> void:
	floor_light_energy = light.energy
	if wall_light:
		wall_light_energy =  wall_light.energy


func _process(delta: float) -> void:
	if not show_creature:
		power = max(0.0, power - power_drop_rate * how_many_creatures_in_zone() * delta)
		
		#countdown progressing
		flicker_time_left -= delta
		
		#flicker_roll
		if flicker_time_left <= 0: #si il n'y'a pas de coupure en cours
			var flicker_ratio = clamp(power / FLICKER_THRESHOLD, 0.0, 1.0)
			var chance = lerp(MAX_FLICKER_CHANCE, 0.0, flicker_ratio)
			if randf() < chance: #tire entre 0 et 1 et regarde si c'est inférieur à chance
				flicker_time_left = randf_range(FLICKER_MIN_DURATION, FLICKER_MAX_DURATION)
	
		#apply energy when it's not flickering
		var brightness: float
		if flicker_time_left > 0 or power == 0.0: 
			brightness = 0.0
		else:
			brightness = lerp(MIN_BRIGHTNESS, 1.0, power)
			
		light.energy = floor_light_energy * brightness
		if wall_light:
			wall_light.energy = wall_light_energy * brightness

func get_intensity_at(pos: Vector2) -> float:
	var distance_to_source = pos.distance_to(light.global_position)
	var ratio = clamp(distance_to_source / light_range, 0.0, 1.0)
	var intensity = lerp(light.energy, 0.0, ratio)
	return intensity

func how_many_creatures_in_zone() -> int:
	var list = get_overlapping_bodies()
	var count: int = 0
	for body in list:
		if body is Creature:
			count += 1
	return count
