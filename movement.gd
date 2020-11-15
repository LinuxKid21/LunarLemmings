extends Object


static func collide_obstacles(mover):
	if mover.is_on_floor() or mover.is_on_ceiling():
		mover.velocity.y = 0
		
	if mover.is_on_wall():
		mover.velocity.x = 0

static func grapple_acceleration(mover, delta):
	if mover.grapple_acceleration:
		mover.velocity += mover.grapple_acceleration * delta

static func running_friction(mover, delta):
	if mover.is_on_floor() and mover.velocity.x != 0:
		var horizontal_dir = 1 if mover.velocity.x > 0 else -1
		var opposite = -horizontal_dir
		mover.velocity.x += opposite * delta * 1000
		horizontal_dir = 1 if mover.velocity.x > 0 else -1
		if horizontal_dir == opposite:
			mover.velocity.x = 0
