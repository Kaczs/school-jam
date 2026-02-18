## Find enemies in range, rotate and shoot
extends TowerBase
var targets:Array[RigidBody2D]
@onready var turret:Sprite2D = $Tower
@onready var cooldown_timer:Timer = $Cooldown
var projectile = preload("res://Scenes/projectile.tscn")

func _process(_delta):
	if targets.is_empty() == false:
		# Face the enemy
		var angle = global_position.angle_to_point(targets[0].global_position)
		turret.rotation = angle + PI/2
		if cooldown_timer.is_stopped():
			cooldown_timer.start()		

func _on_attack_range_body_entered(body: Node2D) -> void:
	if body.get_node_or_null("HealthComponent"):
		# Exclude self?
		targets.append(body)

func _on_attack_range_body_exited(body: Node2D) -> void:
	if body.get_node_or_null("HealthComponent"):
		targets.erase(body)
	pass # Replace with function body.


func _on_cooldown_timeout() -> void:
	if targets.is_empty() == false:
		print("Creating projectile")
		var new_projectile = projectile.instantiate()
		new_projectile.assign_target(targets[0])
		get_tree().get_root().add_child(new_projectile)
		new_projectile.position = position
		#new_projectile.position = position
