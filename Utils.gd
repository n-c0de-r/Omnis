extends Node

var doubleCounter:	int	= 1 # 1=normal, 2=doubles each button
var mirrorShift:	int	= 0 # 0=normal, 2=mirrors color
var spiralCounter:	int	= 1 # 1=normal, increases every round
var timerFactor:	int	= 1 # 1=normal, 2=doubles animation time
var playDirection:	int	= 1 # 1=normal (forward), -1=reverse

# Possible choices
##enum trials {ROTATE, DOUBLE, MIRROR, SPIRAL}
#enum cues {COLOR, AUDIO, SYMBOL, SHAKE}
#enum modes {NORMAL, REVERSE, FLIP, RANDOM}
#enum sounds {INSTUMENT, SOUNDS, VOICE, ANIMAL}
#enum symbols {NONE, ARROWS, SHAPES, ANIMAL}

# Text strings
var texts: Dictionary = {
	"colors": ["Blue", "Red", "Yellow", "Green"]
}

var symbols: Dictionary = {
	"Animals": ["Dog", "Cow", "Cat", "Chick"]
}

var textset = "colors"

var symbolset = "Animals"

# First time running the game?
var first_run: bool = true

# gaming options and presets to start with

# Trials, Strings: Rotate, Double, Mirror, Spiral
var trials: Array = ["Rotate"] # none at start

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
	if "Spiral" in trials:
		spiralCounter += 1
	if "DoubleTimer" in access:
		timerFactor *= 2
	if mode == "Reverse":
		playDirection = -1 # reverse	
	if mode == "Flip":
		playDirection *= -1 # flip direction
	if mode == "Random":
		playDirection *= randomOne() #random
	pass


func _ready():
	if Settings.first_run:
		get_tree().change_scene("res://scenes/InputScreen.tscn")
	else:
		get_tree().change_scene("res://scenes/TitleScreen.tscn")


#Generates a -1 or +1 only
func randomOne():
	randomize()
	return (randi()%2) * 2 - 1
