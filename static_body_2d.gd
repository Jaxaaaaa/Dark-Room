extends StaticBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var full_occluder: LightOccluder2D = $FullOccluder
@onready var foot_occluder: LightOccluder2D = $FootOccluder
var tween 

func _ready() -> void:
	set_behind(false)

func set_behind(is_behind: bool) -> void:
	full_occluder.visible = not is_behind
	foot_occluder.visible = is_behind
	var target_alpha = 0.1 if is_behind else 1.0
	if tween: #si un tween existe on le kill pour éviter les problèmes lors d'entrées et sorties rapides
		tween.kill()
	tween = create_tween() #On créer le tween pour animer le fade du mur
	tween.tween_property(sprite, "modulate:a", target_alpha, 0.3)
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player_group"):
		set_behind(true)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player_group"):
		set_behind(false)
		
