extends Node2D

@export var gravity: float
@export var particle_size: float
@export_range(0.0, 1.0) var collision_damping: float
@export var bounds_size: Vector2

var particle_position: Vector2
var particle_velocity: Vector2


func _process(delta: float) -> void:
	particle_velocity += Vector2.DOWN * gravity * delta
	particle_position += particle_velocity * delta
	resolve_collisions()
	
	queue_redraw()

func _draw() -> void:
	draw_circle(particle_position, particle_size, Color.LIGHT_BLUE)
	draw_rect(Rect2(-bounds_size.x / 2, -bounds_size.y / 2, bounds_size.x, bounds_size.y), Color.BLUE, false, 1.0)

func resolve_collisions():
	var half_bounds_size = bounds_size / 2 - Vector2.ONE * particle_size
	if abs(particle_position.x) > half_bounds_size.x:
		particle_position.x = half_bounds_size.x * sign(particle_position.x)
		particle_velocity.x *= -collision_damping
	if abs(particle_position.y) > half_bounds_size.y:
		particle_position.y = half_bounds_size.y * sign(particle_position.y)
		particle_velocity.y *= -collision_damping
