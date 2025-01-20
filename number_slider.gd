@tool
extends HBoxContainer

signal update_value(prop_name: String, new_value: Vector2)

@export var display_name: String:
    set(value):
        display_name = value
        $Label.text = value
@export var property_name: String
@export var lower_range: Vector2:
    set(value):
        lower_range = value
        %HSliderX.min_value = value.x
        %SpinBoxX.min_value = value.x
        %HSliderY.min_value = value.y
        %SpinBoxY.min_value = value.y

@export var upper_range: Vector2:
    set(value):
        upper_range = value
        %HSliderX.max_value = value.x
        %SpinBoxX.max_value = value.x
        %HSliderY.max_value = value.y
        %SpinBoxY.max_value = value.y

var default_value: Vector2
var current_value: Vector2

#func _on_h_slider_value_changed(value: float) -> void:
    ##$HSlider.value = value
    ##$SpinBox.value = value
#
    #update_value.emit(property_name, value)
#
#
#func _on_spin_box_value_changed(value: float) -> void:
    #_on_h_slider_value_changed(value)

func set_value(value: Vector2):
    current_value = value
    %HSliderX.value = value.x
    %SpinBoxX.value = value.x
    %HSliderY.value = value.y
    %SpinBoxY.value = value.y


func _on_h_slider_y_value_changed(value: float) -> void:
    pass # Replace with function body.


func _on_spin_box_y_value_changed(value: float) -> void:
    pass # Replace with function body.


func _on_h_slider_x_value_changed(value: float) -> void:
    %SpinBoxX.value = value
    %HSliderX.value = value
    current_value.x = value


func _on_spin_box_x_value_changed(value: float) -> void:
    _on_h_slider_x_value_changed(value)
