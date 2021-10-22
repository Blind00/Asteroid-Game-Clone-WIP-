extends Area2D

var speed = 500

func _ready():
	add_to_group("B")

func _physics_process(delta):
	position += transform.x * speed * delta 

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Area2D_body_entered(body):
	if body.is_in_group("P"):
		queue_free()
	else:
		pass
