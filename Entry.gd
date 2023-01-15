extends HBoxContainer

var data := "" setget _set_data

onready var line_edit: LineEdit = $Control/LineEdit
onready var label: Label = $Control/Label
onready var edit: Button = $Edit
onready var remove: Button = $Remove

func _ready() -> void:
	line_edit.text = data
	label.text = data
	
	var _err := line_edit.connect("text_entered", self, "_on_line_edit_text_entered")
	_err = edit.connect("pressed", self, "_on_edit_button_pressed")
	_err = remove.connect("pressed", self, "_on_remove_button_pressed")


func edit_mode() -> void:
	_on_edit_button_pressed()


func _on_line_edit_text_entered(value: String) -> void:
	_set_data(value)
	edit.show()
	line_edit.hide()


func _set_data(value: String) -> void:
	data = value
	line_edit.text = value
	label.text = value


func _on_edit_button_pressed() -> void:
	edit.hide()
	line_edit.show()
	line_edit.grab_focus()
	line_edit.select_all()


func _on_remove_button_pressed() -> void:
	queue_free()
