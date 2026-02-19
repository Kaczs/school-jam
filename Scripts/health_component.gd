class_name HealthComponent extends Node
var max_health:int
var health:int

func take_damage(amount):
	health -= amount
	if health <= 0:
		get_parent().queue_free()