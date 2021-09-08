extends KinematicBody2D

export var speed = 200
export var friction = 0.01
export var acceleration = 0.01
export (float) var max_health = 20

var laser_bolt = preload("res://Scenes/P_Laser.tscn")
var ability = preload("res://Scenes/p_Bullet.tscn")
var velocity = Vector2()
var can_shield = true
var moving = false
var shield_up = false
var shield_charge = 5
var laser_charge = 10

func _ready():
	add_to_group("player")
	yield(get_tree(),"idle_frame")
	get_tree().call_group("ene","set_player",self)

func get_input():
	var input = Vector2()
	if Input.is_action_pressed('Right'):
		input.x += 1
		moving = true
	if Input.is_action_pressed('Left'):
		input.x -= 1
		moving = true
	if Input.is_action_pressed("Down"):
		input.y +=1
		moving = true
	if Input.is_action_pressed("Up"):
		input.y -=1
		moving = true
	if Input.is_action_just_pressed("Shoot"):
		if shield_up == true:
			pass
		else:
			shoot()
	if Input.is_action_just_pressed("Ability"):
		if shield_charge != 0:
			Shield()
			can_shield()
		else:
			pass
		$Timers/ShieldLifeTime.start()
	if Input.is_action_just_pressed("Restart"):
		get_tree().reload_current_scene()
	return input

func _physics_process(delta):
	var direction = get_input()
	if direction.length() > 0:
		velocity = lerp(velocity, direction.normalized() * speed, acceleration)
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction)
	velocity = move_and_slide(velocity)
	look_at(get_global_mouse_position())

func can_shield():
	if can_shield == true:
		$Timers/ShieldTimer.start()
		can_shield = false

func moving():
	if moving == true:
		$Sprites/b2_05/ThrustPart1.emitting = true
		$Sprites/b2_06/ThrustPart2.emitting = true

func checkdeath():
	if max_health == 0:
		dead()
	else: 
		pass

func dead(): 
	get_tree().reload_current_scene()
	pass

func Shield():
	shield_charge -= 1
	var abi = ability.instance()
	add_child(abi)
	abi.transform = $Shield.transform
	shield_up = true
	checkshield()

func checkshield():
	if shield_charge == 0:
		RechargeShield()
		print("Shield Charge Depleted")
	if shield_charge != 0:
		pass

func RechargeShield():
	$Timers/RechargeShield.start()

func shoot():
	var las = laser_bolt.instance()
	owner.add_child(las)
	las.transform = $Gun.global_transform

func get_time():
	return OS.get_ticks_msec()/1000.0

func _on_Ouch_body_entered(body):
	if body.is_in_group("b"):
		print('Hit! by bullet')
		max_health -= 2
		checkdeath()
	if body.is_in_group("ene"):
		print("Hit! by Enemy")
		max_health -= 10
		checkdeath()
	if body.is_in_group("B"):
		print("Hit! by bomb")
		max_health -= 5
		checkdeath()
 
func _on_ShieldTimer_timeout():
	can_shield = true

func _on_ShieldLifeTime_timeout():
	shield_up = false

func _on_CheckDeath_timeout():
	checkdeath()

func _on_RechargeShield_timeout():
	shield_charge = 5
	print("Shield Recharged!")
