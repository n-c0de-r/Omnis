extends Node

# Possible choices
##enum trials {ROTATE, DOUBLE, MIRROR, SPIRAL}
#enum cues {COLOR, AUDIO, SYMBOL, SHAKE}
#enum modes {NORMAL, REVERSE, FLIP, RANDOM}
#enum sounds {INSTUMENT, SOUNDS, VOICE, ANIMAL}
#enum symbols {NONE, ARROWS, SHAPES, ANIMAL}

# First time running the game?
var first_run: bool = true

# gaming options and presets to start with

# Trials, Strings: Rotate, Double, Mirror, Spiral
var trials: Array = [] # none at start

# Cues for Buttons, Strings:
# Color:		Buttons flash if set
# Sounds:		Piano, Violin, Speech, Animal
# Symbols:		None, Arrows, Shapes, Animals
# Vibration:	Use vibration if available
var cues: Array = ["Color", "Piano"]

# Accessibility options
var access: Array = ["Speech", "Subtitle", "Slow", "BigFonts"]

# Available Modes: Normal, Reverse, Flip, Random
var mode: String = "Normal" # normal

# volume options
var min_vol: int = 0
var max_vol: int = 100 
var volume: int = 50 # range 0-100

# Update constants
func update():
	if "DoubleTimer" in access:
		Numbers.timerFactor *= 2
	if Settings.mode == "Reverse":
		Numbers.playDirection = -1 # reverse	
	if Settings.mode == "Flip":
		Numbers.playDirection *= -1 # flip direction
	if Settings.mode == "Random":
		Numbers.playDirection *= _randomOne() #random
	pass


func _ready():
	if Settings.first_run:
		get_tree().change_scene("res://scenes/InputScreen.tscn")
	else:
		get_tree().change_scene("res://scenes/TitleScreen.tscn")

#Generates a -1 or +1 only
func _randomOne():
	randomize()
	return (randi()%2) * 2 - 1
