# NEEDS REWRITING ------------------------------------------------------------
extends Node2D

var current_page = 0
onready var name_label = $MainLayer/Name
onready var img_label = $MainLayer/Image
onready var type_label = $MainLayer/Type
onready var desc = $MainLayer/Description

onready var FILE_normal_enemy = "res://assets/descriptions/DESC_normal_enemy.txt"


func load_file(file):
	var f = File.new()
	f.open(file, File.READ)
	while not f.eof_reached():
		var line = f.get_line()
		print(line)
	f.close()
	return


func _ready():
	current_page = 1


func _process(_delta):
	match (current_page):
		1:
			load_file(FILE_normal_enemy)


func _on_previousPressed():
	current_page -= 1
	if current_page <= 0:
		current_page = 6


func _on_nextPressed():
	current_page += 1
	if current_page > 6:
		current_page = 1
