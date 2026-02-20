class_name HealthComponent extends Node
var max_health:int
var health:int

func take_damage(amount):
	health -= amount
	SoundManager.play_global(SoundFiles.hit_sound, get_tree().get_root())
	if health <= 0:
		EventBus.emit_signal("enemy_has_died", get_parent())
		get_parent().queue_free()