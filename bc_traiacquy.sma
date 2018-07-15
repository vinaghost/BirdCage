#include <bc_core>
#include <bc_qua>
#define PLUGIN "BirdCage: TRAI AC QUY"
#define VERSION "1.0"
#define AUTHOR "VINAGHOST"

new Array:g_Name

enum _:TOTAL_FORWARDS {
	PRE = 0,
	POST
}
enum _:{
	OK = 0,
	NANGLUC
}
new g_forward[TOTAL_FORWARDS]
new g_ForwardResult

public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	g_forward[PRE] = CreateMultiForward("bc_an_pre", ET_IGNORE, FP_CELL, FP_CELL)
	g_forward[POST] = CreateMultiForward("bc_an_post", ET_IGNORE, FP_CELL, FP_CELL)
	
}
public plugin_natives()
{
	register_native("bc_acquy_register", "bc_acquy_register")
	
	g_Name = ArrayCreate(32, 1)
}
public bc_lanhqua(id) {
	ExecuteForward(g_forward[USE_BUTTON_PRE], g_ForwardResult, id)
	if (g_ForwardResult > 0)
	{
		new menu = menu_create("\r[Lồng chim] \yChọn Haki", "choose_menu")
		menu_additem( menu, "QUAN SAT")
		menu_additem( menu, "BA VUONG")
		menu_setprop( menu, MPROP_NUMBER_COLOR, "\r" );
		menu_setprop( menu, MPROP_EXITNAME, "Thoát" );
		menu_display( id, menu );
	}
	else 
		ExecuteForward(g_forward[USE_BUTTON_POST], g_ForwardResult, id)
}
public bc_acquy_register(plugin_id, num_params) {
	new name[32]
	get_string(1, name, charsmax(name))
	
	ArrayPushString(g_Name, name)
	
	g_Count++
	return g_Count - 1;
}
