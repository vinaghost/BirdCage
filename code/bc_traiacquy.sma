#include <bc_core>
#include <bc_qua>

#define PLUGIN "BirdCage: TRAI AC QUY"
#define VERSION "1.0"
#define AUTHOR "VINAGHOST"

new Array:g_Name, Array:g_delay, Array:g_active, Array:g_type

new acquy
new nangluc, p_nangluc[33], choosen
enum _:TOTAL_FORWARDS {
	KICH_HOAT,
	END
}
new g_forward[TOTAL_FORWARDS]
new g_ForwardResult

enum {
	PARAMECIA,
	ZOAN,
	LOGIA
}

new iExplosion, textmsg
new g_Count

new active, delay


public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	g_forward[KICH_HOAT] = CreateMultiForward("bc_taq_kichhoat", ET_IGNORE, FP_CELL, FP_CELL)
	g_forward[END] = CreateMultiForward("bc_taq_end", ET_IGNORE, FP_CELL, FP_CELL)
	
	acquy = bc_qua_register("Trai ac quy" , KHAC)
	
	textmsg = get_user_msgid("SayText")
	
	register_clcmd("say /taq", "chotuitaq", ADMIN_BAN)
	/*register_clcmd("say /botaq", "botaq", ADMIN_BAN)
	register_clcmd("say /delay", "say_delay", ADMIN_BAN)
	register_clcmd("Say /active", "say_active", ADMIN_BAN)*/
}
public plugin_precache(){
	
	iExplosion = precache_model("sprites/bexplo.spr");
}
public plugin_natives()
{
	register_native("bc_acquy_register", "_bc_acquy_register")
	register_native( "bc_acquy_name", "_bc_acquy_name");
	register_native( "bc_acquy", "_bc_acquy");
	register_native( "bc_acquy_delay", "_bc_acquy_delay")
	
	g_Name = ArrayCreate(32, 1)
	g_delay = ArrayCreate()
	g_active = ArrayCreate()
	g_type = ArrayCreate()
	
}

public say_delay(id) 
	client_mau(id, "Delay: %s", Get_BitVar(delay,id) ? "Co":"Khong")
	
public say_active(id) 
	client_mau(id, "Active: %s", Get_BitVar(active,id) ? "Co":"Khong")
public bc_lanhqua(id, id_qua){
	if ( id_qua == acquy ) {
		if ( Get_BitVar(nangluc, id) )
		{
			new menu = menu_create("\r[Lồng chim] \yBạn đang là người năng lực.^nBạn có muốn nhận thêm ?", "choose_menu")
			menu_additem( menu, "Co")
			menu_additem( menu, "Khong")
			menu_setprop( menu, MPROP_NUMBER_COLOR, "\r" );
			menu_setprop( menu, MPROP_PERPAGE, 0)
			
			
			menu_display( id, menu );
		}
		else
		{
			
			new id_trai
			do (  id_trai = random_num(0, g_Count - 1) )
			while (Get_BitVar(choosen, id_trai))
				
			cho_taq(id, id_trai)
		}
	}
}
public bc_progress(progress) {
	if (progress == START)
	{
		nangluc = 0
		choosen = 0
		arrayset(p_nangluc, 0, 33)
	}
}
public bc_use_post(id) { 
	if(!Get_BitVar(delay, id))
	{
		ExecuteForward(g_forward[KICH_HOAT], g_ForwardResult, id, p_nangluc[id])
		
		Set_BitVar(delay,id)
		set_task(float(ArrayGetCell(g_delay, p_nangluc[id])), "de_delay", id + 938)
		
		if( ArrayGetCell(g_active, p_nangluc[id]) ) 
		{
			Set_BitVar(active, id)
			set_task(float(ArrayGetCell(g_active, p_nangluc[id])), "de_active", id + 908)
		}
		
		client_mau(id, "Da kich hoat nang luc trai ac quy")
	}
}
public de_delay(id) {
	id-=938;
	UnSet_BitVar(delay, id)
	
	ExecuteForward(g_forward[END], g_ForwardResult, id, p_nangluc[id])
	client_mau(id, "Da co lai kha nang su dung nang luc")
}
public de_active(id) {
	id-=908;
	UnSet_BitVar(active, id)
	client_mau(id, "Da het kha nang su dung nang luc")
}
public choose_menu(id, menu, item) 
{
	switch (item)
	{
		case 0: kill_player_right_now(id)
			// case 1: nothing to do ._.
	}
	menu_destroy(menu)
}

public kill_player_right_now(id) {
	if( !is_alive(id) ) return;
	
	ExplodePlayer(id)
	user_silentkill(id)
}
public chotuitaq(id) {
	if( !is_alive(id)) return
	new menu = menu_create("\r[Lồng chim] \yNhan TAQ", "taq_menu")
	new name[33]
	for (new i = 0; i < g_Count; i++)
	{
		ArrayGetString(g_Name, i, name, charsmax(name))
		menu_additem(menu, name)
	}
	
	menu_setprop( menu, MPROP_NUMBER_COLOR, "\r" );	
	menu_setprop( menu, MPROP_EXITNAME, "Thoat" );
	menu_display( id, menu );
}
public taq_menu(id, menu, item) 
{
	if( item == MENU_EXIT)	menu_destroy(menu)
	
		
	if( !Get_BitVar(choosen, item) ) {
		
		if( Get_BitVar(nangluc,id) )
			botaq(id) 
			
		cho_taq(id, item)
		menu_destroy(menu)
	}
	else 
		menu_display( id, menu );
	
}
public botaq(id) 
{
	UnSet_BitVar(choosen, p_nangluc[id])
	UnSet_BitVar(nangluc, id)
}
ExplodePlayer(id) {
	
	new Float:forigin[3];
	new origin[3];
	pev(id, pev_origin, forigin);
	for(new i=0;i<3;i++)
		origin[i]=floatround(forigin[i]);
	
	Create_TE_EXPLOSION( origin, iExplosion, 140, 12);
	
	set_pev(id, pev_velocity, Float:{0.0, 0.0, 2000.0});
}

Create_TE_EXPLOSION( origin[3], iSprite, scale, frameRate, flags=0 ){
	
	// Explosion
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY);
	write_byte(TE_EXPLOSION); // TE_EXPLOSION
	write_coord(origin[0]); // startorigin
	write_coord(origin[1]);
	write_coord(origin[2]);
	write_short(iSprite); // sprite
	write_byte(scale);
	write_byte(frameRate);
	write_byte(flags);
	message_end();
	
}
public _bc_acquy_register(plugin_id, num_params) {
	new name[32]
	get_string(1, name, charsmax(name))
	
	ArrayPushString(g_Name, name)
	ArrayPushCell(g_delay, get_param(2))
	ArrayPushCell(g_active, get_param(3))
	ArrayPushCell(g_type, get_param(4))
	
	g_Count++
	return g_Count - 1;
}

public _bc_acquy_name(plugin_id, num_params)
{
	new iLen = get_param( 3 );
	new id = get_param( 1 )
	new szName[ 32 ];
	ArrayGetString(g_Name, p_nangluc[id], szName, charsmax(szName))
	get_user_name( id, szName, iLen );
	
	set_string( 2, szName, iLen );
}
public _bc_acquy(plugin_id, num_params)
{
	return Get_BitVar(nangluc, get_param(1))
}
public _bc_acquy_delay(plugin_id, num_params)
{
	return Get_BitVar(delay, get_param(1))
}
stock client_mau(const id, const input[], any:...) 
{ 
	new count = 1, players[32] 
	
	static msg[191] 
	
	vformat(msg, 190, input, 3) 
	format(msg, 190,"!g[Lồng chim] !y%s",msg)
	
	replace_all(msg, 190, "!g", "^4") 
	replace_all(msg, 190, "!y", "^1") 
	replace_all(msg, 190, "!t", "^3") 
	replace_all(msg, 190, "!t2", "^0") 
	
	if (id) players[0] = id; else get_players(players, count, "ch") 
	
	for (new i = 0; i < count; i++) 
	{ 
		if (is_connected(players[i])) 
		{ 
			message_begin(MSG_ONE_UNRELIABLE, textmsg, _, players[i]) 
			write_byte(players[i]) 
			write_string(msg) 
			message_end() 
		} 
	}  
}
stock cho_taq(id, id_trai) {
	Set_BitVar(choosen, id_trai)
	Set_BitVar(nangluc, id)
	p_nangluc[id] = id_trai
	
	new name[33], p_name[33]
	
	ArrayGetString(g_Name, id_trai, name, charsmax(name))
	
	get_user_name(id, p_name, charsmax(p_name))
	client_mau(id, "%s đã trở thành người mang năng lực của trái %s", p_name, name)
}
