extends CharacterBody2D
class_name Creature 

var is_in_light = false

const SPEED = 100.0
const SLOW_SPEED = SPEED * 0.5
var player
func _ready():
	player = get_tree().get_first_node_in_group("Player_group") #On va chercher le node player

func _physics_process(_delta: float) -> void: 
	var direction = position.direction_to(player.position) #on récupère la position du joueur pour la sauvegarder dans une var direction
	look_at(player.position)
	if not is_in_light :
		velocity = direction * SPEED
	else: 
		velocity = direction * SLOW_SPEED
	move_and_slide()
