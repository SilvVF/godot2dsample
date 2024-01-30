class_name Grapple
extends Sprite2D

@export var character: CharacterBody2D

enum State {
	START, NONE, IN_PROGRESS
}

var grappling: State = State.NONE
var cords: Vector2 = Vector2.ZERO

var first_target: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:	
	if grappling == State.START:
		first_target = cords - character.global_position
		grappling = State.IN_PROGRESS
		print("first", first_target)
		
	if grappling == State.IN_PROGRESS:
		var target = cords - character.global_position
		print("target", target)
		
		var passed_x = signf(first_target.x) != signf(target.x)
		var passed_y = signf(first_target.y) != signf(target.y)
		
		if passed_x && passed_y:
			grappling = State.NONE
			return
		
		character.velocity += Vector2(100 * signf(target.x), 100 * signf(target.y))
		
		character.velocity = character.velocity.clamp(Vector2(-600, -600), Vector2(600, 600))
		character.move_and_slide()
		
		if passed_x:
			character.velocity.x = lerp(character.velocity.x, 0.0, 0.5)
		if passed_y:
			character.velocity.y = lerp(character.velocity.y, 0.0, 0.5)
		

	

func _process(delta: float) -> void:
	pass


func _input(event):
	if Input.is_action_just_pressed("grapple"):
		if event is InputEventMouseButton && grappling == State.NONE:
			grappling = State.START
			cords = event.position
		if event is InputEventMouseButton && grappling == State.IN_PROGRESS:
			grappling = State.NONE
