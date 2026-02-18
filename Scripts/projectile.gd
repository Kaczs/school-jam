class_name Projectile 
extends Node2D
@export var speed:float = 100
@export var damage = 50
var target:RigidBody2D
var health:HealthComponent

func _process(delta):
	if target != null:
		position += position.direction_to(target.position) * speed * delta
	# In case target died from something else while projectile is in flight
	if target == null:
		queue_free()
	
func assign_target(body:RigidBody2D):
	health = body.get_node_or_null("HealthComponent")
	target = body
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == target:
		if health != null:
			health.take_damage(50)
		queue_free()
