class_name HealthComponent extends Node
@export var max_health:int
var health:int

func _ready():
	health = max_health

func take_damage(amount):
	health -= amount
	if health <= 0:
		print("ded")
		get_parent().queue_free()