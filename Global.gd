extends Node

# Possible choices
enum challanges {ROTATE, MIRROR, DOUBLE, CURVED}
enum cues {COLOR, AUDIO, SYMBOL, SHAKE}
enum modes {NORMAL, REVERSE, FLIP, CHAOS}
enum sounds {INSTUMENT, SOUNDS, VOICE, ANIMAL}
enum symbols {NONE, ARROWS, SHAPES, ANIMAL}

# First time running the game?
var first_run: bool = true

# gaming options and presets to start with
var challenge: Array = [] # none
var cue: Array = [0, 1] # color & audio
var mode: int = 0 # normal
var sound: int = 0 # start with instruments
var symbol: int = 0 # start without symbols

# accessibility options
var speech: bool = true
var subtitle: bool = true

# volume options
var min_vol: int = 0
var max_vol: int = 100 
var volume: int = 50 # range 0-100

func _ready():
	if Settings.first_run:
		get_tree().change_scene("res://scenes/InputScreen.tscn")
	else:
		get_tree().change_scene("res://scenes/TitleScreen.tscn")
