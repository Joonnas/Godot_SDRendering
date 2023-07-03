@tool
extends EditorPlugin
class_name SD_Renderer

const b64_database = {
	"A": 0b000000,
	"B": 0b000001,
	"C": 0b000010,
	"D": 0b000011,
	"E": 0b000100,
	"F": 0b000101,
	"G": 0b000110,
	"H": 0b000111,
	"I": 0b001000,
	"J": 0b001001,
	"K": 0b001010,
	"L": 0b001011,
	"M": 0b001100,
	"N": 0b001101,
	"O": 0b001110,
	"P": 0b001111,
	"Q": 0b010000,
	"R": 0b010001,
	"S": 0b010010,
	"T": 0b010011,
	"U": 0b010100,
	"V": 0b010101,
	"W": 0b010110,
	"X": 0b010111,
	"Y": 0b011000,
	"Z": 0b011001,
	
	"a": 0b011010,
	"b": 0b011011,
	"c": 0b011100,
	"d": 0b011101,
	"e": 0b011110,
	"f": 0b011111,
	"g": 0b100000,
	"h": 0b100001,
	"i": 0b100010,
	"j": 0b100011,
	"k": 0b100100,
	"l": 0b100101,
	"m": 0b100110,
	"n": 0b100111,
	"o": 0b101000,
	"p": 0b101001,
	"q": 0b101010,
	"r": 0b101011,
	"s": 0b101100,
	"t": 0b101101,
	"u": 0b101110,
	"v": 0b101111,
	"w": 0b110000,
	"x": 0b110001,
	"y": 0b110010,
	"z": 0b110011,
	
	"0": 0b110100,
	"1": 0b110101,
	"2": 0b110110,
	"3": 0b110111,
	"4": 0b111000,
	"5": 0b111001,
	"6": 0b111010,
	"7": 0b111011,
	"8": 0b111100,
	"9": 0b111101,
	"+": 0b111110,
	"/": 0b111111
}

func _enter_tree():
	# Initialization of the plugin goes here.
	add_custom_type("SD_Button", "Button", preload("res://addons/stablediffusion_renderer/Stable_Renderer.gd"), null)
	pass


func _exit_tree():
	# Clean-up of the plugin goes here.
	pass
