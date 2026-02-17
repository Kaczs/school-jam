extends RigidBody2D
class_name Enemy

@onready var navigation_agent:NavigationAgent2D = $NavigationAgent2D
@export var speed := 2000
var external_velocity:Vector2

func _ready() -> void:
	var goal = get_tree().get_nodes_in_group("Goal")
	if goal[0]:
		navigation_agent.target_position = goal[0].global_position
	else:
		push_error(self, " could not find Goal")


func _physics_process(delta: float) -> void:
	if !navigation_agent.is_target_reachable():
		push_error(self, " is lost (target not reachable)")
		return
	
	if !navigation_agent.is_target_reached():
		var nav_point_direction = to_local(navigation_agent.get_next_path_position()).normalized()
		apply_central_force(speed * nav_point_direction * delta + external_velocity)
	else:
		goal_reached()


func goal_reached():
	pass
	#kill enemy and remove health from player
