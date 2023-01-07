extends KinematicBody2D

var dir_x			:int	 	= 0;
var dir_y			:int	 	= 0;
var acel			:int	 	= 300;
var forca_pulo		:int		= 250;
var longe			:bool	 	= false;
var posi_init		:Vector2	= Vector2.ZERO;
var posi_queda		:Vector2	= Vector2.ZERO;
onready var sprite	:Node		= $Sauro;
var montaria		:bool		= false;

func _ready():
	posi_init = self.global_position;

func respaw() -> void:
	if self.global_position[1] > 1000:
		dir_y					 = 0;
		self.global_position	 = posi_init;

func _physics_process(delta):
	if get_parent().has_method("get_player"):
		if get_parent().get_player() == null:
			 return 0
	else:
		return 0
	
	respaw();
	
	var vel				:float		= .51
	var virar			:bool 		= true
	var up				:Vector2 	= Vector2(0, -1)
	var minha_posi		:Vector2	= self.global_position
	var player_posi		:Vector2	= get_parent().get_player().global_position
	var dist			:Vector2 	= minha_posi - player_posi
	var player			:KinematicBody2D	= get_parent().get_player()
	dir_x = 0;
	
	
	# movimentação do pet
	if not is_on_floor():
		dir_y += 9.86;
	else:
		dir_y = 0;
	if not montaria:
		if dist[0] > 100 or longe:
			longe = true;
			if dist[0] > 30:
				pular();
				dir_x -= 1 * acel;
			else:
				longe = false
		if dist[0] < -100 or longe:
			longe = true;
			if dist[0] < -30:
				pular();
				dir_x += 1 * acel;
			else:
				longe = false
		# config orientação do pet
		if player_posi[0] > minha_posi[0]:
			$pular_plataforma.rotation_degrees 	= -90;
			virar 								= false;
		else:
			$pular_plataforma.rotation_degrees 	= 90;
			virar 								= true;
		
		$Sauro.flip_h = virar;
		
	elif montaria:
		player.global_position = $sela.global_position;
		if Input.is_action_just_pressed("ui_montar"):
			montaria			= false;
			Global.montando		= false;
			Global.dir_y		= 0;
			Global.dir_y 		-= forca_pulo;
		if $peh_0.is_colliding() or $peh_1.is_colliding():
			posi_queda = self.global_position - Vector2(32, 32);
		if Input.is_action_pressed("ui_up"):
			if $peh_0.is_colliding() or $peh_1.is_colliding():
				dir_y 	= 0;
				dir_y 	-= forca_pulo;
		if Input.is_action_pressed("ui_right"):
			dir_x 						+= vel * acel;
			sprite.flip_h 				= false;
			player.anim_sprite.flip_h 		= false;
			$sela.global_position[0]	= self.global_position[0];
			$peh_0.position[0] 		= -8;
		if Input.is_action_pressed("ui_left"):
			dir_x 						-= vel * acel;
			sprite.flip_h 				= true;
			player.anim_sprite.flip_h 		= true;
			$sela.global_position[0]	= self.global_position[0];
			$peh_0.position[0] 			= 8;
	
	move_and_slide( Vector2(dir_x, dir_y), up );

func pular() -> void:
	if  $peh_0.is_colliding() or $peh_1.is_colliding():
		if $pular_plataforma.is_colliding():
			dir_y 	= 0;
			dir_y 	-= forca_pulo;
		elif not $pular_abismo.is_colliding():
			dir_y 	= 0;
			dir_y 	-= forca_pulo;
			acel 	= 400
