extends Node

const DEFAULT_ROOT_COLOUR: Color = Color.ROYAL_BLUE
const DEFAULT_BRANCH1_COLOUR: Color = Color.CORNFLOWER_BLUE
const DEFAULT_BRANCH2_COLOUR: Color = Color.STEEL_BLUE
const DEFAULT_BRANCH3_COLOUR: Color = Color.LIGHT_STEEL_BLUE
const DEFAULT_BRANCH4_COLOUR: Color = Color.LIGHT_GRAY
const DEFAULT_BRANCH5_COLOUR: Color = Color.LIGHT_SLATE_GRAY
const DEFAULT_VAR_COLOUR: Color = Color.DIM_GRAY

var tree_name: String = "Root"
var tree = {}
var forge: Node = null

var tree_button_disable: bool = true
var click_sound: bool = true
var ask_close: bool = true
var start_full: bool = false
var root_colour: Color = DEFAULT_ROOT_COLOUR
var branch1_colour: Color = DEFAULT_BRANCH1_COLOUR
var branch2_colour: Color = DEFAULT_BRANCH2_COLOUR
var branch3_colour: Color = DEFAULT_BRANCH3_COLOUR
var branch4_colour: Color = DEFAULT_BRANCH4_COLOUR
var branch5_colour: Color = DEFAULT_BRANCH5_COLOUR
var var_colour: Color = DEFAULT_VAR_COLOUR
