class_name HealthComponent extends Node
var max_health:int
var health:int
@onready var blood_particles:GPUParticles2D = $BloodParticles
@onready var timer:Timer = blood_particles.get_node_or_null("Timer")

func take_damage(amount):
	health -= amount
	SoundManager.play_global(SoundFiles.hit_sound, get_tree().get_root())
	if health <= 0:
		if blood_particles != null:
			timer.start()
			blood_particles.reparent(get_tree().get_root())
			blood_particles.global_position = get_parent().global_position		
			blood_particles.emitting = true
		EventBus.emit_signal("enemy_has_died", get_parent())
		get_parent().queue_free()
