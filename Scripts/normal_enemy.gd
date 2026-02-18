extends RigidBody2D
class_name Enemy

@onready var navigation_agent:NavigationAgent2D = $NavigationAgent2D
@export var speed := 2000

func _ready() -> void:
	var goal = get_tree().get_nodes_in_group("Goal")
	if goal[0]:
		navigation_agent.target_position = goal[0].global_position
	else:
		push_warning(self, " could not find Goal")


func _physics_process(delta: float) -> void:
	#if !navigation_agent.is_target_reachable():
		#push_warning(self, " is lost (target not reachable)")
		#return
	if !navigation_agent.is_target_reached():
		var next_pos = navigation_agent.get_next_path_position()
		var direction = (next_pos - global_position).normalized()
		var velocity = direction * speed
		# need to set the navigation agent velocity so it can calculate avoidance
		# and use that instead
		navigation_agent.velocity = velocity 
		
	else:
		goal_reached()

	#print(linear_velocity)	
	#	var nav_point_direction = to_local(navigation_agent.get_next_path_position()).normalized()
	#	apply_central_force(speed * nav_point_direction * delta)
	#else:
	#	goal_reached()


func goal_reached():
	pass
	#kill enemy and remove health from player


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	apply_central_force(safe_velocity - linear_velocity)
