extends Node

# Possible choices
enum challanges {ROTATE, MIRROR, DOUBLE, BLIND}
enum cues {COLOR, AUDIO, SYMBOL, SHAKE}
enum modes {NORMAL, REVERSE, FLIP, CHAOS}
enum sounds {INSTUMENT, SOUNDS, VOICE, ANIMAL}

# gaming options
var challenge: Array = [] # none
var cue: Array = [0, 1] # color & audio preset
var mode: int = 0 # normal oreset
var sound: int = 0 # start with instruments
# accessibility options
var speech: bool = true
var subtitle: bool = true
# volume options
var min_vol: int = 0
var max_vol: int = 100 
var volume: int = 50 # range 0-100
