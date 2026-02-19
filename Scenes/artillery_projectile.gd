class_name ArtilleryProjectile 
extends RigidBody2D
@export var speed:float = 50
@export var damage = 50
@onready var animated_sprite:AnimatedSprite2D = $AnimatedSprite2D
@onready var timer:Timer = $Timer
@onready var explosion_area:Area2D = $ExpolsionArea
@onready var explosion_particles:GPUParticles2D = $ExplosionParticles
var target_last_pos := Vector2()
var target:RigidBody2D

func _ready():
	if animated_sprite != null:
		animated_sprite.play()
	timer.start()

func _physics_process(_delta:float):
	if target_last_pos != null:
		var direction = global_position.direction_to(target_last_pos)
		# Should not be doing linear velocity directly
		linear_velocity = direction * speed
	if global_position.distance_to(target_last_pos) <= 10:
		print("reached point")
		# BOOM

func assign_target(body:RigidBody2D):
	target = body
	target_last_pos = target.global_position

func _on_body_shape_entered(_body_rid: RID, body: Node, _body_shape_index: int, _local_shape_index: int) -> void:
	print("HITITITIIT")
	# Unlike the arrow tower, this one just does damage to whoever it hits
	var health:HealthComponent = body.get_node_or_null("HealthComponent")
	if health != null:
		explode()

func explode():
	linear_velocity = Vector2.ZERO
	explosion_area.monitoring = true
	# Wait to check overlaps (I hate this error)
	await  get_tree().physics_frame
	var to_explode = explosion_area.get_overlapping_bodies()
	for body in to_explode:
		var health = body.get_node_or_null("HealthComponent")
		if health != null:
			health.take_damage(damage)
	explosion_particles.reparent(get_tree().get_root())
	explosion_particles.emitting = true
	queue_free()

# If it takes too long to reach it's point
func _on_timer_timeout() -> void:
	explode()
