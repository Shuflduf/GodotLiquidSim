@tool
extends HBoxContainer

signal update_value(prop_name: String, new_value: float)

@export var display_name: String:
    set(value):
        display_name = value
        $Label.text = value
@export var property_name: String
@export var lower_range: float:
    set(value):
        lower_range = value
        %HSlider.min_value = value
        %SpinBox.min_value = value
@export var upper_range: float:
    set(value):
        upper_range = value
        %HSlider.max_value = value
        %SpinBox.max_value = value

var default_value: float

func _on_h_slider_value_changed(value: float) -> void:
    $HSlider.value = value
    $SpinBox.value = value

    update_value.emit(property_name, value)


func _on_spin_box_value_changed(value: float) -> void:
    _on_h_slider_value_changed(value)

func set_value(value: float):
    %HSlider.value = value
    %SpinBox.value = value
