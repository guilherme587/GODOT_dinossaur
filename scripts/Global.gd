extends Node

onready var mao		:Node		= null
var posi_inicial	:Vector2	= Vector2.ZERO
var posi_queda		:Vector2	= Vector2.ZERO
var posi_player		:Vector2	= Vector2.ZERO
var adulto			:bool 		= false
var olhando_dir		:bool		= false
var hited			:bool		= false
var montando		:bool		= false
var offset			:float		= 0
var dir_y			:float		= 0
var dir_x			:float 		= 0
var vida			:float		= 300
var pontos			:int		= 0
const VIDA_MAX		:float		= 300.0
var dano			:int		= 100
var dist_dash		:int		= 3000


var ultima_cena		:NodePath		= "res://GUI/menu.tscn"
