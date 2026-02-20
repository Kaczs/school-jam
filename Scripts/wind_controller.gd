extends Node2D

@export var wind_force = 80000
## The radius of the circle local wind can affect
@export var local_size:float = 600 
## Max number of stored 'wind' uses
@export var max_wind := 3
@export var wind_regeneration_rate := 5.0
@export var current_wind:int
var drag_direction = Vector2(0, 0)
var accumulated_drag = Vector2.ZERO
var local_wind_mode = true	
var starting_point:Vector2
var is_dragging:bool = false
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
	if is_dragging:
		queue_redraw()

# Getting the mouse drags to know what direction to send wind.
func _input(event: InputEvent) -> void:
	# We've started a drag
	if Input.is_action_just_pressed("wind"):
		is_dragging = true
		starting_point = get_viewport().get_mouse_position()
		accumulated_drag = Vector2.ZERO
	# Start tracking the drag motion
	if Input.is_action_pressed("wind"):
		if event is InputEventMouseMotion:
			accumulated_drag += event.relative
	# Once we release the button act on that motion
	if Input.is_action_just_released("wind") and is_dragging:
		is_dragging = false
		# Dont have enough to cover the cost
		if current_wind <= 0:
			return
		drag_direction = accumulated_drag.normalized()
		# If they didnt actually drag their mouse, dont do anything
		if drag_direction == Vector2.ZERO:
			return
		if local_wind_mode == false:
			global_wind(drag_direction)
		else:
			local_wind(drag_direction)
		current_wind -= 1
		EventBus.emit_signal("wind_changed", current_wind)
		EventBus.emit_signal("moving_pathfinding_objects")
		queue_redraw()

## Use wind on everything in the group
func global_wind(direction:Vector2):
	var targets = get_tree().get_nodes_in_group("affected by wind")
	for target in targets:
		target.parent_body.apply_force(direction * (wind_force * 0.8))
		# One off case, artillery shots should stop flying to goal when hit w/ wind
		if target.parent_body is ArtilleryProjectile:
				target.parent_body.hit_by_wind()
	create_global_wind_particles(direction)

## Use wind on bodies near the mouse, as opposed to the entire group
## local wind is a bit stronger
func local_wind(direction:Vector2):
	var targets = get_tree().get_nodes_in_group("affected by wind")
	for target in targets:
		if target.global_position.distance_to(starting_point) <= local_size:
			target.parent_body.apply_force(direction * wind_force)
			# One off case, artillery shots should stop flying to goal when hit w/ wind
			if target.parent_body is ArtilleryProjectile:
				target.parent_body.hit_by_wind()
	# We wanna create particles even if the player isnt pushing anything
	create_local_wind_particles(direction)
	
func create_local_wind_particles(direction:Vector2):
	local_wind_particles.global_position = starting_point
	var process_mat:ParticleProcessMaterial = local_wind_particles.process_material
	process_mat.direction = Vector3(direction.x, direction.y, 0.0)
	local_wind_particles.emitting = true

func create_global_wind_particles(direction:Vector2):
	var process_mat:ParticleProcessMaterial = global_wind_particles.process_material
	process_mat.direction = Vector3(direction.x, direction.y, 0.0)
	global_wind_particles.emitting = true

func _draw():
	if not is_dragging or current_wind <= 0:
		return
	# Make a circle for local wind so players can tell where they're aiming
	if local_wind_mode:
		draw_circle(starting_point, local_size, Color(1, 1, 1, 0.3))
	if accumulated_drag.length() > 5.0:
		var line_end = starting_point + accumulated_drag.normalized() * 120.0
		draw_line(starting_point, get_viewport().get_mouse_position(), Color(1, 1, 1, 0.6), 3.0)

func _on_regen_timer_timeout() -> void:
	if current_wind < max_wind:
		current_wind += 1
		# Primarily for the UI element showing wind
		EventBus.emit_signal("wind_changed", current_wind)
