extends Control
@onready var settings = $CenterContainer/Settings2
@onready var menu_buttons = $CenterContainer/VBoxContainer

func _on_resume_pressed() -> void:
	self.hide()


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://MainMenu/main.tscn")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("UI_open_menu") and not self.visible:
		self.show()
		return
	if event.is_action_pressed("UI_Back"):
		if not menu_buttons.visible:
			menu_buttons.show()
			settings.hide()
		else:
			self.hide()


func _on_settings_pressed() -> void:
	settings.show()
	menu_buttons.hide()
