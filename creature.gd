extends CharacterBody2D
class_name Creature 

var is_in_light = false
const SPEED = 100.0
const SLOW_SPEED = SPEED * 0.5
var player
func _ready():
	player = get_tree().get_first_node_in_group("Player_group") #On va chercher le node player
func _physics_process(_delta: float) -> void: 
	var direction = global_position.direction_to(player.global_position) #on récupère la position du joueur pour la sauvegarder dans une var direction
	look_at(player.global_position)
	$RayCast2D.target_position = to_local(player.global_position) #on traduit la position global de la target en position locale
	if is_in_light and not $RayCast2D.is_colliding() :
		velocity = direction * SLOW_SPEED
	else: 
		velocity = direction * SPEED
	move_and_slide()
