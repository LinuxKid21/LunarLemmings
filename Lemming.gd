extends KinematicBody2D

class_name Lemming
func get_class(): return "Lemming"
func is_class(type): return type == get_class() or .is_class(type)

const MovementUtil = preload("movement.gd")

var grapple_acceleration = null
var velocity = Vector2()
var speed = 250
var GRAVITY = 9.8 * 100

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity.x = speed

func _physics_process(delta):
	MovementUtil.collide_obstacles(self)
	
	MovementUtil.grapple_acceleration(self, delta)
	
	MovementUtil.running_friction(self, delta)
#	if grapple_acceleration:
#		velocity += delta * grapple_acceleration
#		if velocity.length() > 1000:
#			velocity = velocity.normalized() * 1000
#	else:
#		if is_on_floor() or is_on_ceiling():
#			velocity.y = 0
#		velocity.x = speed
		
	velocity.y += delta * GRAVITY
		
	move_and_slide(velocity, Vector2(0, -1))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
