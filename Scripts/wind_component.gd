class_name WindComponent
extends Node2D

## toggled = true means you want wind to affect it
@export var toggled := true

var parent_body:RigidBody2D

func _ready():
	parent_body = get_parent() as RigidBody2D
	if parent_body == null:		
		push_error("Parent of WindComponent needs to be a Rigid Body")
	if toggled == true:
		add_to_group("affected by wind")

## This will be used in game to lock towers and obstacles in place,
## and prevent wind from affecting them.
func toggle():
	SoundManager.play_global(SoundFiles.lock, self)
	toggled = not toggled
	if toggled == false:
		remove_from_group("affected by wind")
		parent_body.freeze = true
	if toggled == true:
		add_to_group("affected by wind")
		parent_body.freeze = false

func _on_button_pressed() -> void:
	# Freeze any momentum the object has, allows for cool slide cancel stuff
	parent_body.linear_velocity = Vector2(0,0)
	toggle()