extends CharacterBody2D


const SPEED = 160.0
const JUMP_VELOCITY = -400.0
var coyote_time := 0.1  # Seconds you can still jump after leaving ground
var coyote_timer := 0.0
var jump_count = 0


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D



func _physics_process(delta: float) -> void:
	# Track coyote timer
	if is_on_floor():
		jump_count = 0
		coyote_timer = coyote_time  # Reset timer when on ground
		
	else:
		coyote_timer -= delta  # Count down when in air

	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
		


# Handle jump (allow jump while timer > 0)
	if Input.is_action_just_pressed("ui_accept") and coyote_timer > 0:
		velocity.y = JUMP_VELOCITY
		coyote_timer = 0  # Prevent double-jumping abuse
		jump_count = 1  # First jump used
		
# Double jump if player has 13+ coins
	elif Input.is_action_just_pressed("ui_accept") and global.coin >= 13 and jump_count == 1:
		velocity.y = JUMP_VELOCITY
		jump_count = 2  # Used double jump
# --- Extra coyote time if player has 10+ coins ---
	if global.coin >= 10:
		coyote_time = 1


	# Movement
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
		
		
	if direction == 0:
		animated_sprite_2d.play("idle")
	else:
		animated_sprite_2d.play("run")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
