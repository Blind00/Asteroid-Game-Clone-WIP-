extends KinematicBody2D

var speed = 1000

func ready():
	add_to_group("P")

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _physics_process(delta):
	position += transform.x * speed * delta
