extends CharacterBody2D
class_name Creature 

const FULL_LIGHT = 8.6
const SPEED = 100.0
const LIT_ATTACK_SPEED = SPEED * 0.5
const WANDER_SPEED = SPEED * 0.25
const ATTACK_SPEED = SPEED * 1.5
const FADE_SPEED = 10.0
const VISIBILITY_GAIN = 3
const WANDER_RADIUS = 150.0
const ARRIVAL_DISTANCE = 10.0
const AGGRESSION_RATE_BASE = 0.05
const AGGRESSION_RATE_MULTIPLIER = 0.25
const MAX_CONTAGION = 0.9
enum Behavior { ERRATIC, ATTACK }
@export var behavior: Behavior
@export var visible_debug: bool
var received_light: float
var body_scale: Vector2
var player: CharacterBody2D
var tween_breath: Tween
var target_point: Vector2 = Vector2.INF
var aggression_gauge: float = 0.0
var aggression_rate: float = AGGRESSION_RATE_BASE
@onready var creature_body: Sprite2D = $Body

func _ready():
	player = get_tree().get_first_node_in_group("Player_group") #On va chercher le node player
	body_scale = creature_body.scale
	modulate.a = 0.0
	breath()

func _physics_process(delta: float) -> void: 
	#look_at(player.global_position)
	received_light = max_light_in_zone()
	var light_ratio = clamp(received_light / FULL_LIGHT, 0.0, 1.0) #borne l'intensité entre 0 et 1, 0 pas de light, 1 full light
	var visibility = clamp(light_ratio * VISIBILITY_GAIN, 0.0, 1.0)
	if visible_debug: 
		modulate.a = 1.0
	else:
		modulate.a = lerp(modulate.a, visibility, FADE_SPEED * delta) #change l'alpha selon la luminosité reçue
	match behavior:
		Behavior.ERRATIC:
			var creature_count = get_tree().get_nodes_in_group("Creatures").size() - 1
			aggression_rate = AGGRESSION_RATE_BASE + (AGGRESSION_RATE_BASE * creature_count *  AGGRESSION_RATE_MULTIPLIER)
			aggression_gauge += aggression_rate * delta
			if aggression_gauge >= 1:
				start_attack()
				if visible_debug:
					$Debug_polygon.visible = true
				return
			if ($Wandering_Timer.is_stopped() and target_point == Vector2.INF) or has_reached_target_point():
				target_point = choose_a_new_point()
				$Wandering_Timer.start()
			if target_point == Vector2.INF:
				velocity = Vector2.ZERO
			else:
				var direction = global_position.direction_to(target_point)
				velocity = direction * WANDER_SPEED
		Behavior.ATTACK:
			var direction = global_position.direction_to(player.global_position) #on récupère la direction du joueur pour la sauvegarder dans une var direction
			velocity = direction * lerp(ATTACK_SPEED, LIT_ATTACK_SPEED, light_ratio) #transforme la lumière reçu en vitesse comprise entre ATTACK_SPEED et LIT_ATTACK_SPEED
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
	
func take_hit():
	queue_free()
	


func _on_attack_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and behavior == Behavior.ATTACK:
		body.die()


func choose_a_new_point() -> Vector2:
	for _i in range(10):
		var tested_point = Vector2(randf_range(global_position.x - WANDER_RADIUS, global_position.x + WANDER_RADIUS), randf_range(global_position.y - WANDER_RADIUS, global_position.y + WANDER_RADIUS))
		var tested_point_local = to_local(tested_point)
		$Wandering_RayCast2D2.target_position = tested_point_local
		$Wandering_RayCast2D2.force_raycast_update()
		if not $Wandering_RayCast2D2.is_colliding():
			return tested_point
	return Vector2.INF

func has_reached_target_point() -> bool:
	return global_position.distance_to(target_point) < ARRIVAL_DISTANCE


func _on_wandering_timer_timeout() -> void:
	target_point = Vector2.INF

func start_attack() -> void:
	behavior = Behavior.ATTACK
	var list = $Attack_Area2D.get_overlapping_bodies()
	var creatures_in_range = $Contagion_Area2D.get_overlapping_bodies()
	for body in creatures_in_range:
		if body is Creature:
			var distance = global_position.distance_to(body.global_position)
			var distance_ratio = clamp(distance / $Contagion_Area2D/Contagion_CollisionShape2D.shape.radius, 0.0, 1.0)
			var contagion_amount = lerp(MAX_CONTAGION, 0.0, distance_ratio)
			body.add_aggression(contagion_amount)
	for body in list:
		if body is Player:
			body.die()

func add_aggression(amount: float) -> void:
	aggression_gauge += amount
