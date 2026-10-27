extends CharacterBody2D
class_name Creature 

const FULL_LIGHT = 8.6
const SPEED = 100.0
const SLOW_SPEED = SPEED * 0.5

var received_light: float
var body_scale: Vector2
var player: CharacterBody2D
var tween_breath: Tween
@onready var creature_body: Sprite2D = $Body

func _ready():
	player = get_tree().get_first_node_in_group("Player_group") #On va chercher le node player
	body_scale = creature_body.scale
	breath()

func _physics_process(_delta: float) -> void: 
	var direction = global_position.direction_to(player.global_position) #on récupère la position du joueur pour la sauvegarder dans une var direction
	#look_at(player.global_position)
	received_light = max_light_in_zone()
	print(received_light)
	var ratio = clamp(received_light / FULL_LIGHT, 0.0, 1.0) #borne l'intensité entre 0 et 1, 0 pas de light, 1 full light
	velocity = direction * lerp(SPEED, SLOW_SPEED, ratio) #transforme la lumière reçu en vitesse comprise entre SPEED et SLOW_SPEED
	move_and_slide()
	
func breath():
	var factor = randf_range(0.50, 1.50)
	var duration = randf_range(1.5, 2.5)
	tween_breath = create_tween()
	tween_breath.tween_property(creature_body, "scale", creature_body.scale * factor, duration,)
	tween_breath.tween_property(creature_body, "scale", body_scale, duration)
	tween_breath.finished.connect(breath) #rappel la fonction lorsque le dernier breath est terminé

func max_light_in_zone() -> float:
	var max_intensity = 0.0
	var list = $LightDetectorArea2D.get_overlapping_areas()
	for area in list:
		if area is LightZone:
			$RayCast2D.target_position = to_local(area.light.global_position)
			$RayCast2D.force_raycast_update()
			if not $RayCast2D.is_colliding():
				var intensity_in_zone = area.get_intensity_at(global_position)
				if intensity_in_zone > max_intensity:
					max_intensity = intensity_in_zone
	return max_intensity
	
