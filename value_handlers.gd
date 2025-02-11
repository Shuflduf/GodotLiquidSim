extends VBoxContainer

@onready var world: Node2D = $"../../../.."

func _ready() -> void:
    for child in get_children():
        child.set_value(world.get(child.property_name))
        child.set(&"default_value", world.get(child.property_name))
        child.update_value.connect(
            func(prop_name: String, new_value: Variant):
                world.set(prop_name, new_value)
        )


func _on_reset_pressed() -> void:
    for child in get_children():
        child.set_value(child.default_value)


func _on_view_controls_pressed() -> void:
    $"../Popup".show()


func _on_popup_popup_hide() -> void:
    $"../Popup".hide()
