extends Control

var blue:	TextureButton
var red:	TextureButton
var yellow:	TextureButton
var green:	TextureButton

func _ready():
	blue =		$TxtBtn_BLUE
	red =		$TxtBtn_RED
	yellow =	$TxtBtn_YELLOW
	green =		$TxtBtn_GREEN

# Checks if all buttons are currently not pressed
func areAllReleased():
	return !blue.pressed and !red.pressed and !yellow.pressed and !green.pressed

# Releases all buttons, if needed
func releaseAll():
	blue.simulateRelease()
	red.simulateRelease()
	yellow.simulateRelease()
	green.simulateRelease()
