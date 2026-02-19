extends RigidBody2D
class_name Enemy

@onready var navigation_agent:NavigationAgent2D = $NavigationAgent2D
@onready var sprite:Sprite2D = $Icon
@export var speed := 2000
@export var health := 75

func _ready() -> void:
	var goal = get_tree().get_nodes_in_group("Goal")
	if goal[0]:
		navigation_agent.target_position = goal[0].global_position
	else:
		push_warning(self, " could not find Goal")
	var health_component:HealthComponent = get_node_or_null("HealthComponent")
	health_component.max_health = health
	health_component.health = health


func _physics_process(_delta: float) -> void:
	#if !navigation_agent.is_target_reachable():
		#push_warning(self, " is lost (target not reachable)")
		#return
	if !navigation_agent.is_target_reached():
		var next_pos = navigation_agent.get_next_path_position()
		var direction = (next_pos - global_position).normalized()
		var velocity = direction * speed
		var angle = sprite.global_position.angle_to_point(next_pos)
		sprite.rotation = angle + PI/2
		# need to set the navigation agent velocity so it can calculate avoidance
		# and use that instead
		navigation_agent.velocity = velocity 
		
	else:
		goal_reached()

func goal_reached():
	pass
	#kill enemy and remove health from player


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	# Apply the force to steer
	apply_central_force(safe_velocity - linear_velocity)
