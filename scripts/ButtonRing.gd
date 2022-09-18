extends Control

onready var blue:	TextureButton = $TxtBtn_BLUE
onready var red:	TextureButton = $TxtBtn_RED
onready var yellow:	TextureButton = $TxtBtn_YELLOW
onready var green:	TextureButton = $TxtBtn_GREEN

# Checks if all buttons are currently not pressed
func areAllReleased():
	return !blue.pressed and !red.pressed and !yellow.pressed and !green.pressed

# Releases all buttons, if needed
func releaseAll():
	for btn in self.get_children():
		btn.simulateRelease()
