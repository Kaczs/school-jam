extends Node
@export var goal_hp := 5

func _on_area_2d_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	# just using health to test for enemies for now
	var health:HealthComponent = body.get_node_or_null("HealthComponent")
	if health != null:
		health.take_damage(999999)
		goal_hp -= 1
		if goal_hp <= 0:
			EventBus.emit_signal("player_lose")
