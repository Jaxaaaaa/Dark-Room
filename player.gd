extends CharacterBody2D
class_name Player

const SPEED = 300.0


func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED
	look_at(get_global_mouse_position())
	move_and_slide()


func _on_flash_light_area_2d_body_entered(body: Node2D) -> void:
	if body is Creature:
		body.is_in_light = true 


func _on_flash_light_area_2d_body_exited(body: Node2D) -> void:
	if body is Creature:
		body.is_in_light = false
