extends Node2D

@export var playing: bool
@export var gravity: float = 150.0
@export var particle_size: float = 8.0
@export var smoothing_radius: float = 100.0
@export var particle_spacing: float = 8.0
@export var target_density: float
@export var pressure_multiplier: float
@export var mass: float = 1.0

@export_range(0.0, 1.0) var collision_damping: float = 1.0
@export_range(2, 500) var num_particles: int = 100
@export var bounds_size: Vector2 = Vector2(100.0, 100.0)

var particle_positions: Array[Vector2]
var particle_velocities: Array[Vector2]
var densities: Array[float]

func _ready() -> void:
    particle_positions.resize(num_particles)
    particle_velocities.resize(num_particles)
    densities.resize(num_particles)

    var particles_per_row = int(sqrt(num_particles))
    @warning_ignore("integer_division")
    var particles_per_col = (num_particles - 1) / particles_per_row + 1
    var spacing = particle_size * 2 + particle_spacing

    for i in num_particles:
        var x = (i % particles_per_row - particles_per_row / 2.0 + 0.5) * spacing
        @warning_ignore("integer_division")
        var y = (i / particles_per_row - particles_per_col / 2.0 + 0.5) * spacing
        particle_positions[i] = Vector2(x, y)
        particle_velocities[i] = Vector2.ZERO

    update_densities()


func _process(delta: float) -> void:
    if playing:
        for i in range(particle_positions.size()):
            particle_velocities[i] += Vector2.DOWN * gravity * delta
            densities[i] = calculate_density(particle_positions[i])

            if densities[i] == 0:
                continue

            var pressure_force = calculate_pressure_force(i)

            var pressure_accel = pressure_force / densities[i]
            particle_velocities[i] += pressure_accel * delta

            particle_positions[i] += particle_velocities[i] * delta
            resolve_collisions(i)
    else:
        _ready()

    queue_redraw()

func _draw() -> void:
    for i in particle_positions.size():
        draw_circle(particle_positions[i], particle_size, Color.LIGHT_BLUE)
    draw_rect(Rect2(-bounds_size.x / 2, -bounds_size.y / 2, bounds_size.x, bounds_size.y), Color.BLUE, false, 1.0)

func update_densities():
    for i in num_particles:
        densities[i] = calculate_density(particle_positions[i])

func resolve_collisions(index: int):
    var half_bounds_size = bounds_size / 2 - Vector2.ONE * particle_size
    if abs(particle_positions[index].x) > half_bounds_size.x:
        particle_positions[index].x = half_bounds_size.x * sign(particle_positions[index].x)
        particle_velocities[index].x *= -collision_damping
    if abs(particle_positions[index].y) > half_bounds_size.y:
        particle_positions[index].y = half_bounds_size.y * sign(particle_positions[index].y)
        particle_velocities[index].y *= -collision_damping

static func smoothing_kernel(radius: float, dst: float) -> float:
    if dst >= radius:
        return 0.0

    var volume = PI * pow(radius, 4) / 6
    return (radius - dst) * (radius - dst) / volume

static func smoothing_kernel_derivative(dst: float, radius: float) -> float:
    if dst >= radius:
        return 0
    var p_scale = -12 / (PI * pow(radius, 4))
    return (dst - radius) * p_scale

func calculate_density(point: Vector2) -> float:
    var density = 0.0
    const MASS = 1.0

    for pos in particle_positions:
        var dst = (pos - point).length()
        var influence = smoothing_kernel(smoothing_radius, dst)
        density += MASS * influence

    return density

func calculate_pressure_force(particle_index: int) -> Vector2:
    var pressure_force = Vector2.ZERO

    for i in particle_positions.size():
        if particle_index == i:
            continue

        var offset = particle_positions[i] - particle_positions[particle_index]
        var dst = offset.length()
        var dir = offset / dst if dst != 0 else random_dir()
        var slope = smoothing_kernel_derivative(dst, smoothing_radius)
        var density = densities[i]
        var shared_pressure = calculate_shared_pressure(density, densities[particle_index])
        pressure_force += shared_pressure * dir * slope * mass / density
    return pressure_force

func convert_density_to_pressure(density: float) -> float:
    var density_error = density - target_density
    var pressure = density_error * pressure_multiplier
    return pressure

func calculate_shared_pressure(dens_a: float, dens_b: float) -> float:
    var pres_a = convert_density_to_pressure(dens_a)
    var pres_b = convert_density_to_pressure(dens_b)
    return (pres_a + pres_b) / 2

static func random_dir() -> Vector2:
    var angle = randf_range(0, TAU)
    return Vector2(sin(angle), cos(angle))
