@tool
extends HBoxContainer

signal update_value(prop_name: String, new_value: bool)

@export var display_name: String:
    set(value):
        display_name = value
        $Label.text = value
@export var property_name: String

var default_value: bool

func set_value(value: bool):
    $CheckButton.button_pressed = value

func _on_check_button_toggled(toggled_on: bool) -> void:
    update_value.emit(property_name, toggled_on)
