extends HBoxContainer


signal answer_pressed(likelihood)


func _ready() -> void:
	for i in get_child_count():
		var _err := get_child(i).connect("pressed", self, "_on_answer_button_pressed", [i])


func toggle_buttons(enabled: bool) -> void:
	for child in get_children():
		child.disabled = not enabled


func _on_answer_button_pressed(idx: int) -> void:
	emit_signal("answer_pressed", idx)
