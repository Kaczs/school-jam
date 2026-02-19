extends Node

@export var wind_force = 80000
## The radius of the circle local wind can affect
@export var local_size:float = 600 
## Max number of stored 'wind' uses
@export var max_wind := 3
@export var wind_regeneration_rate := 5.0
var current_wind := 2
var drag_direction = Vector2(0, 0)
var accumulated_drag = Vector2.ZERO
var local_wind_mode = true	
@onready var local_wind_particles:GPUParticles2D = $LocalWindParticles
@onready var global_wind_particles:GPUParticles2D = $GlobalWindParticles
@onready var regen_timer:Timer = $RegenTimer

func _ready():
	regen_timer.wait_time = wind_regeneration_rate
	regen_timer.start()

func _process(_delta):
	if Input.is_action_just_pressed("local_wind"):
		local_wind_mode = true
		EventBus.emit_signal("wind_mode", "local")
	if Input.is_action_just_pressed("global_wind"):
		EventBus.emit_signal("wind_mode", "global")
		local_wind_mode = false
	

# Getting the mouse drags to know what direction to send wind.
func _input(event: InputEvent) -> void:
	# If we press wind button, start tracking the motion.
	if Input.is_action_pressed("wind"):
		if event is InputEventMouseMotion:
			accumulated_drag += event.relative
	# Once we release the button act on that motion
	if Input.is_action_just_released("wind") and current_wind > 0:
		drag_direction = accumulated_drag.normalized()
		# If they didnt actually drag their mouse, dont do anything
		if drag_direction == Vector2(0, 0):
			return
		if local_wind_mode == false:
			global_wind(drag_direction)
		else:
			local_wind(drag_direction)
		current_wind -= 1
		EventBus.emit_signal("wind_changed", current_wind)
		EventBus.emit_signal("moving_pathfinding_objects")
		# Need to rebake pathfinding on timer
		accumulated_drag = Vector2.ZERO

## Use wind on everything in the group
func global_wind(direction:Vector2):
	var targets = get_tree().get_nodes_in_group("affected by wind")
	for target in targets:
		target.parent_body.apply_force(direction * wind_force)
		# Slow enemies temp. when hitting them with wind?
	create_global_wind_particles(direction)

## Use wind on bodies near the mouse, as opposed to the entire group
## local wind is a bit stronger
func local_wind(direction:Vector2):
	var targets = get_tree().get_nodes_in_group("affected by wind")
	for target in targets:
		if target.global_position.distance_to(get_viewport().get_mouse_position()) <= local_size:
			#print("Target distance: ", target.global_position.distance_to(get_viewport().get_mouse_position()))
			target.parent_body.apply_force(direction * (wind_force*1.7))
	# We wanna create particles even if the player isnt pushing anything
	create_local_wind_particles(direction)
	
func create_local_wind_particles(direction:Vector2):
	local_wind_particles.global_position = get_viewport().get_mouse_position()
	var process_mat:ParticleProcessMaterial = local_wind_particles.process_material
	process_mat.direction = Vector3(direction.x, direction.y, 0.0)
	local_wind_particles.emitting = true

func create_global_wind_particles(direction:Vector2):
	var process_mat:ParticleProcessMaterial = global_wind_particles.process_material
	process_mat.direction = Vector3(direction.x, direction.y, 0.0)
	global_wind_particles.emitting = true


func _on_regen_timer_timeout() -> void:
	if current_wind < max_wind:
		current_wind += 1
		# Primarily for the UI element showing wind
		EventBus.emit_signal("wind_changed", current_wind)
