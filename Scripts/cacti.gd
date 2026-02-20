extends StaticBody2D

func _on_damage_area_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	var health:HealthComponent = body.get_node_or_null("HealthComponent")
	if health != null:
		health.take_damage(75)
