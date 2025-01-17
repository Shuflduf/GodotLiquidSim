extends Node2D

@export var gravity: float

var particle_position: Vector2
var particle_velocity: Vector2


func _process(delta: float) -> void:
	particle_velocity += Vector2.DOWN * gravity * delta
	particle_position += particle_velocity * delta
	queue_redraw()

func _draw() -> void:
	draw_circle(particle_position, 10, Color.LIGHT_BLUE)
