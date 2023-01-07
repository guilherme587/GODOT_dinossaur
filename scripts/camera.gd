extends Node2D

export var fov = 0;

func _ready():
	$Camera2D.set_zoom( Vector2(.2, .2) );

func _process(delta):
	if get_parent().olhando_dir == true:
		$Camera2D.set_offset( Vector2(fov, 0) );
		print("esquerda ", $Camera2D.get_offset() );
	if get_parent().olhando_dir == false:
		$Camera2D.set_offset( Vector2(fov, 0) );
		print("direita ", $Camera2D.get_offset() );
