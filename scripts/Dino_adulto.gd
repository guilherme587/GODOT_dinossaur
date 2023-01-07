extends KinematicBody2D

var dino_adulto	:Texture	= preload("res://sprites/Dino_adulto.png");
var teste		:Object		= preload("res://cenas/palyer/companheiro_doPalyer/Amigo_sauro.tscn");

func _ready() -> void:
	pass

func respaw() -> void:
	if self.global_position[1] > 1000:
		self.global_position = Vector2(430, 230)

var dir_y:int = 0;

func _physics_process(delta) -> void:
	respaw();


	var acel:int = 200;
	var up:Vector2 = Vector2(0, -1);
	var dir_x:int = 0;

	if not is_on_floor():
# warning-ignore:narrowing_conversion
		dir_y += 9.86;
	else:
		dir_y = 0;
	if Input.is_action_pressed("ui_up"):
		if $peh_0.is_colliding() or $peh_1.is_colliding():
			dir_y 	= 0;
			dir_y 	-= 300;
	if Input.is_action_pressed("ui_right"):
		dir_x 			+= 1 * acel;
		$Dino_adulto.flip_h 	= false;
	if Input.is_action_pressed("ui_left"):
		dir_x 			-= 1 * acel;
		$Dino_adulto.flip_h 	= true;

# warning-ignore:return_value_discarded
	move_and_slide( Vector2(dir_x, dir_y), up);
