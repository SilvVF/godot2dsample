class_name Player
extends CharacterBody2D

@export var movement_speed: float = 500
@export var jump_velocity: float = 2500
@export var x_interp := 0.1
@export var y_interp := 0.05
@export var jump_buffer_time: float = 0.1

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var _jump_buffer_timer: float = 0 :
	set(value): 
		_jump_buffer_timer = maxf(value, 0.0)

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		_jump_buffer_timer = jump_buffer_time

func _physics_process(delta: float) -> void:
	var on_floor: bool = is_on_floor()
	
	if _jump_buffer_timer > 0 && on_floor:
		velocity.y -= jump_velocity
	
	var dir := Input.get_axis("move_left", "move_right")
	# dont set zero velocity for csgo stop handled by lerp below
	if dir != 0:
		velocity.x = movement_speed * dir
 	
	if Input.is_action_pressed("move_down"):
		sprite_2d.play("duck")
		velocity += Vector2.DOWN * 1000 * delta
		velocity = Vector2(
			dir * min(abs(velocity.x * dir), abs(movement_speed * dir / 2)),
			velocity.y
		)
	elif !on_floor:
		sprite_2d.play("jump")
	elif dir != 0:
		sprite_2d.play("walk")
	else:
		sprite_2d.play("idle")	
		
	move_and_slide()
	
	velocity.x = lerp(velocity.x, 0.0, x_interp)
	velocity.y = lerp(velocity.y, float(gravity), y_interp)
	
	
func _process(delta: float) -> void:	
	_jump_buffer_timer -= delta
	var direction := Input.get_axis("move_left", "move_right")
	if direction < 0:
		sprite_2d.flip_h = true
	elif direction > 0:
		sprite_2d.flip_h = false

