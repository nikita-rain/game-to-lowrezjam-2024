class_name ShapeData extends Resource

enum shape_names {
	SQUARE_SMALL, SQUARE, SQUARE_BIG, CIRCLE, 
	TRIANGLE_UP, TRIANGLE_DOWN, TETRIS, CROWN}

var shape_is_aviable = {
	shape_names.SQUARE_SMALL : false, 
	shape_names.SQUARE : true, 
	shape_names.SQUARE_BIG : false, 
	shape_names.CIRCLE : false, 
	shape_names.TRIANGLE_UP : false, 
	shape_names.TRIANGLE_DOWN : false, 
	shape_names.TETRIS : false,
	shape_names.CROWN: false
}

var color_is_aviable = [
	true, true, false, false, 
	false, false, false, false]
