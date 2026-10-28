extends Area2D
#Dans son script il lui faut une trajectoire, un déplacement
#la liberer quand elle touche une autre zone, ou quand elle a 10s de temps de vie
#Le timer doit se lancer dans _ready

const SPEED = 100.0

var trajectory: Vector2 = Vector2.RIGHT
var velocity: Vector2

func _ready() -> void:
	velocity = trajectory * SPEED


func _physics_process(delta: float) -> void:
	global_position += velocity * delta


func _on_timer_timeout() -> void:
	queue_free()
