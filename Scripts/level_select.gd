extends CenterContainer
@onready var button_container = %VBoxContainer

func _ready() -> void:
	var unlocked_levels:Array = LevelManager.unlocked_levels
	for level:PackedScene in unlocked_levels:
		var button:Button = Button.new()
		button.pressed.connect(func():get_tree().change_scene_to_packed(level))
		var button_lable:String = level.resource_path
		button_lable = button_lable.replace("res://Scenes/Levels/", "")
		button_lable = button_lable.replace(".tscn", "")
		button_lable = button_lable.capitalize()
		button.set_text(button_lable)
		button_container.add_child(button)
