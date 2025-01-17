extends Node2D

@export var playing: bool
@export var gravity: float
@export var particle_size: float
@export var particle_spacing: float
@export_range(0.0, 1.0) var collision_damping: float
@export var num_particles: int
@export var bounds_size: Vector2

var particle_positions: Array[Vector2]
var particle_velocities: Array[Vector2]

func _ready() -> void:
    particle_positions.resize(num_particles)
    particle_velocities.resize(num_particles)

    var particles_per_row = int(sqrt(num_particles))
    var particles_per_col = (num_particles - 1) / particles_per_row + 1
    var spacing = particle_size * 2 + particle_spacing

    for i in num_particles:
        var x = (i % particles_per_row - particles_per_row / 2.0 + 0.5) * spacing
        var y = (i / particles_per_row - particles_per_col / 2.0 + 0.5) * spacing
        particle_positions[i] = Vector2(x, y)


func _process(delta: float) -> void:
    if playing:
        for i in particle_positions.size():
            particle_velocities[i] += Vector2.DOWN * gravity * delta
            particle_positions[i] += particle_velocities[i] * delta
            resolve_collisions(i)
    else:
        _ready()

    queue_redraw()

func _draw() -> void:
    for i in particle_positions.size():
        draw_circle(particle_positions[i], particle_size, Color.LIGHT_BLUE)
    draw_rect(Rect2(-bounds_size.x / 2, -bounds_size.y / 2, bounds_size.x, bounds_size.y), Color.BLUE, false, 1.0)

func resolve_collisions(index: int):
    var half_bounds_size = bounds_size / 2 - Vector2.ONE * particle_size
    if abs(particle_positions[index].x) > half_bounds_size.x:
        particle_positions[index].x = half_bounds_size.x * sign(particle_positions[index].x)
        particle_velocities[index].x *= -collision_damping
    if abs(particle_positions[index].y) > half_bounds_size.y:
        particle_positions[index].y = half_bounds_size.y * sign(particle_positions[index].y)
        particle_velocities[index].y *= -collision_damping
