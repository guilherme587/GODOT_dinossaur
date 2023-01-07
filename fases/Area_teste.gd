extends Node2D

onready var inimigos			:Array		= $"inimigos".get_children()
onready var node_inimigos		:Node2D		= $"inimigos"

func _ready():
	pass


func _physics_process(delta):
	if inimigos.empty():
		get_tree().reload_current_scene()


func get_player( lista :Array = get_children() ) -> KinematicBody2D:
	for i in lista:
		if i.name == "player":
			return i;
	
	return null;
	
func inimigos_daFase():
	inimigos = $"inimigos".get_children()
	return inimigos

func noh_inimigos():
	return node_inimigos
