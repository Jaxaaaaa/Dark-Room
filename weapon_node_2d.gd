extends Node2D

class_name Weapon

@export var bullet : PackedScene
@export var fire_rate : float = 5.0
var  _cooldown := 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _cooldown > 0.0:
		_cooldown -= delta

func shoot() -> void:
	if _cooldown <= 0.0:
		print("tir")
		var b = bullet.instantiate()
		b.trajectory = global_transform.x.normalized()
		get_tree().current_scene.add_child(b)
		b.global_transform = $Muzzle_Marker2D.global_transform
		_cooldown = 1.0 / fire_rate
