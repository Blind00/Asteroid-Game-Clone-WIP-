extends KinematicBody2D

var speed = 700

func _ready():
	add_to_group("ene")

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _physics_process(delta):
	position += transform.x * speed * delta 

func _on_e1_Bullet_body_entered(body):
	if body.is_in_group("player"):
		queue_free()
