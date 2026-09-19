@tool

extends StaticBody2D

@export var ramp_width: float = 0.5 # How "thick" the platform is

@onready var collision_polygon: CollisionPolygon2D = $CollisionPolygon2D
@onready var line: Line2D = $Line2D
@onready var point_a: Marker2D = $PointA
@onready var point_b: Marker2D = $PointB
	
func _ready():
	# Make sure it acts as a one-way platform
	collision_polygon.one_way_collision = true
	line.default_color = Color(0.941, 0.69, 0.847, 1.0)
	update_ramp_geometry()
	
func _process(_delta: float) -> void:
	update_ramp_geometry()
	
func update_ramp_geometry():
	# Calculate the direction from A to B
	var a = point_a.position
	var b = point_b.position
	var direction = (b - a).normalized()
	# Calculate a perpendicular vector to give the ramp some thickness
	var normal = Vector2(-direction.y, direction.x) * ramp_width

	# Define the 4 corners of the ramp polygon
	var new_points = PackedVector2Array([
		a - normal/2,
		b - normal/2,
		b + normal/2,
		a + normal/2
	])

	# Assign the new shape to the collision polygon
	collision_polygon.polygon = new_points
	
	# Update the visual component
	line.points = PackedVector2Array([a, b])
	line.width = ramp_width
