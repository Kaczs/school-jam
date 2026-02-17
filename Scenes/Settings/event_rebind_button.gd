extends Button
class_name EventButton

var action:String
var input_event:InputEvent
var mother #the node that made this button, should be the key_binds node in settings
var rebinding := false


func _ready() -> void:
	self.text = input_event.as_text().trim_suffix(" - Physical")
	mother.disable_key_rebinding.connect(_on_disable_key_rebinding)
	self.pressed.connect(_on_pressed)


func _on_pressed() -> void:
	mother.disable_key_rebinding.emit(true)
	rebinding = true
	InputMap.action_erase_event(action,input_event)
	self.text = "new key please"

#stops the player from rebinding multiple actions at once
func _on_disable_key_rebinding(bool) -> void:
	self.set_disabled(bool)

#I use unhandle inputs to stop the mouse from showing up
#I dont think this is the best way to rebind a event to an action but I dont see any problems so far
func _unhandled_input(event: InputEvent) -> void:
	if rebinding:
		InputMap.action_add_event(action,event)
		mother.disable_key_rebinding.emit(false)
		rebinding = false
		self.text = event.as_text()
		input_event = event
