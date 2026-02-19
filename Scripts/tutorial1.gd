extends Node
@export var tutorial_tower:RigidBody2D
@export var bonus_tower:RigidBody2D
@export var spawner:EnemySpawner
@onready var text_label = $RichTextLabel
@onready var text_label2 = $RichTextLabel2
@onready var timer:Timer = $Timer
@onready var wind:WindComponent = tutorial_tower.get_node("WindComponent")
var started_spawner := false

func _on_area_2d_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	# Player successfully slides the tower into out of the box
	if body.is_in_group("tutorial_tower") == true:
		wind.visible = true
		text_label.text = "You can lock towers with [Right Click] in place to prevent wind from affecting them."
		text_label.position.x -= 300
	
func _process(_delta):
	if !wind.is_in_group("affected by wind") and started_spawner == false:
		bonus_tower.visible = true
		spawner.begin_spawns()
		text_label.visible = false
		text_label2.visible = true
		started_spawner = true
		timer.start()
	

func _on_timer_timeout() -> void:
	queue_free()
