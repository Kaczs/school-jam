class_name Projectile 
extends Node2D
@export var speed:float = 100
@export var damage = 25
@onready var animated_sprite:AnimatedSprite2D = $AnimatedSprite2D
var target:RigidBody2D
var health:HealthComponent

func _ready():
	if animated_sprite != null:
		animated_sprite.play()

func _process(delta):
	if target != null:
		global_position += global_position.direction_to(target.global_position) * speed * delta
		var angle = global_position.angle_to_point(target.global_position)
		rotation = angle + PI/2
	# In case target died from something else while projectile is in flight
	if target == null:
		queue_free()
		return
	
func assign_target(body:RigidBody2D):
	health = body.get_node_or_null("HealthComponent")
	target = body

func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body == target:
		if health != null:
			health.take_damage(damage)
		queue_free()