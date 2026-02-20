## Find enemies in range, rotate and shoot
extends TowerBase
var targets:Array[RigidBody2D]
@onready var turret:Sprite2D = $Tower
@onready var cooldown_timer:Timer = $Cooldown
@export var projectile = preload("res://Scenes/projectile.tscn")
@export var needs_lineofsight := true

func _process(_delta):
	if targets.is_empty() == false:
		# Face the enemy
		var angle = global_position.angle_to_point(targets[0].global_position)
		turret.rotation = angle + PI/2
		# Start the timer and spawn an initial shot
		if cooldown_timer.time_left <= 0:
			cooldown_timer.start()
			if needs_lineofsight:
				if check_line_of_sight():
					print("Shooting")
					spawn_projectile()
			else:
				print("Shooting")
				spawn_projectile()
				

func _on_attack_range_body_entered(body: Node2D) -> void:
	if body.get_node_or_null("HealthComponent"):
		# Exclude self?
		targets.append(body)

func _on_attack_range_body_exited(body: Node2D) -> void:
	if body.get_node_or_null("HealthComponent"):
		targets.erase(body)
	pass # Replace with function body.

func spawn_projectile():
	var new_projectile = projectile.instantiate()
	new_projectile.assign_target(targets[0])
	get_tree().get_root().add_child(new_projectile)
	new_projectile.position = position	

func _on_cooldown_timeout() -> void:
	# Every timeout 
	if targets.is_empty() == false:
		if needs_lineofsight:
			if check_line_of_sight():
				spawn_projectile()
		else:
			spawn_projectile()

## Returns true if there's a unobstructed view to the target
func check_line_of_sight():
	# Make the actual ray
	var query = PhysicsRayQueryParameters2D.create(global_position, targets[0].global_position)
	# Exclude self
	query.exclude = [self.get_rid(), targets[0].get_rid()]
	# Prevent enemies (ie. the targets) from counting as blocking the shot
	query.collision_mask = 1
	# Does it hit something or not?
	var result = get_world_2d().direct_space_state.intersect_ray(query)
	if result.is_empty():
		return true
	else:
		return false
