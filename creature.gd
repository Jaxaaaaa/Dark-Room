extends CharacterBody2D
class_name Creature 
@onready var creature_body: Sprite2D = $Body

var is_in_light = false
const SPEED = 100.0
const SLOW_SPEED = SPEED * 0.5

var body_scale
var player
var tween_breath

func _ready():
	player = get_tree().get_first_node_in_group("Player_group") #On va chercher le node player
	body_scale = creature_body.scale
	breath()

func _physics_process(_delta: float) -> void: 
	var direction = global_position.direction_to(player.global_position) #on récupère la position du joueur pour la sauvegarder dans une var direction
	#look_at(player.global_position)
	$RayCast2D.target_position = to_local(player.global_position) #on traduit la position global de la target en position locale
	if is_in_light and not $RayCast2D.is_colliding() :
		velocity = direction * SLOW_SPEED
	else: 
		velocity = direction * SPEED
	move_and_slide()

func breath():
	var factor = randf_range(0.50, 1.50)
	var duration = randf_range(1.5, 2.5)
	tween_breath = create_tween()
	tween_breath.tween_property(creature_body, "scale", creature_body.scale * factor, duration,)
	tween_breath.tween_property(creature_body, "scale", body_scale, duration)
	tween_breath.finished.connect(breath) #rappel la fonction lorsque le dernier breath est terminé
