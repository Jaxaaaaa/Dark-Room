extends CharacterBody2D
class_name Player

const SPEED = 150.0
@export var invincible: bool

func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("Shoot"):
		$Weapon_Node2D.shoot()
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED
	look_at(get_global_mouse_position())
	move_and_slide()

func die():
	if not invincible :
		get_tree().reload_current_scene()
