extends KinematicBody2D

const MovementUtil = preload("movement.gd")

var grappled_object = null
var grappled_location = null
var grapple_acceleration = null


var velocity = Vector2()
var speed = 500
var max_horizontal_speed = 500
var max_vertical_speed = 1000
var GRAVITY = 9.8 * 100


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	MovementUtil.collide_obstacles(self)
	
	velocity.y += delta * GRAVITY
	
	MovementUtil.grapple_acceleration(self, delta)
#	if grapple_acceleration:
#		velocity += grapple_acceleration * delta
#		move_and_slide(velocity, Vector2(0, -1))
#		return
			
	var run_acc = 2.5 if grapple_acceleration else 5
	
	if Input.is_action_pressed('right'):
		if velocity.x < max_horizontal_speed:
			velocity.x += speed * delta * run_acc
	elif Input.is_action_pressed('left'):
		if velocity.x > -max_horizontal_speed:
			velocity.x -= speed * delta * run_acc
	
	# slow down when dragging on the floor
	MovementUtil.running_friction(self, delta)
	
	if Input.is_action_pressed('jump') and is_on_floor():
		velocity.y = -500
		
	move_and_slide(velocity, Vector2(0, -1))


func _cast_ray_towards(towards):
	var space_state = get_world_2d().direct_space_state
	var diff = towards - global_position
	var dir = diff.normalized()
	return space_state.intersect_ray(global_position, global_position + dir * 3000, [self])


func _input(event):
	if event.is_action_pressed("grapple"):
		
		if grappled_object:
			var lemming = grappled_object as Lemming
			if lemming:
				lemming.grapple_acceleration = null
			grappled_object = null
			grappled_location = null
			return
		
		var result = _cast_ray_towards(get_global_mouse_position())
		if result and result.collider:
			grappled_object = result.collider
			grappled_location = result.position
			
			


func _process(delta):
	var grapple = find_node("GrappleLine", false) as Line2D
		
	if grappled_object:
		var lemming = grappled_object as Lemming
		var node2d = grappled_object as Node2D
		
		if lemming:
			var diff = position - lemming.position
			var dir = diff.normalized()
			var magnitude = 3000 # min(diff.length() * 1, 300)
			lemming.grapple_acceleration = dir * magnitude
			
			grapple.set_point_position(1, lemming.global_position - global_position)
			grapple.show()
		elif node2d:
			var diff = grappled_location - global_position
			var dir = diff.normalized()
			var magnitude = 3000 # min(diff.length() * 1, 300)
			grapple_acceleration = dir * magnitude
			
			grapple.set_point_position(1, grappled_location - global_position)
			grapple.show()
	else:
		grapple.hide()
		grapple_acceleration = null
	
	var background_red = .3
	if global_position.y > 3000:
		background_red = (global_position.y - 3000) / 10000 + .3
		if background_red > .5:
			background_red = .5
			
	VisualServer.set_default_clear_color(Color(background_red,0.3,0.3,1.0))
	
