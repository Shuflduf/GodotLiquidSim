extends VBoxContainer

func _ready() -> void:
    for child in get_children():
        child.set_value($"../../..".get(child.property_name))
        child.set(&"default_value", $"../../..".get(child.property_name))
        child.update_value.connect(
            func(prop_name: String, new_value: float):
                $"../../..".set(prop_name, new_value)
        )
