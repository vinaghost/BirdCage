#include <bc_core>
#include <bc_qua>


#define PLUGIN "BirdCage: QUA_MAU"
#define VERSION "1.0"
#define AUTHOR "VINAGHOST"

enum _:TYPE {
	HP_25 = 0,
	HP_25_2,
	HP_25_3,
	HP_25_4,
	HP_25_5,
	HP_50,
	HP_50_2,
	HP_75,
	HP_100,
	HOI
}
new mau[TYPE]
#define HOIMAUGHE 1250
//new hoimau
new hide_wpn, textmsg 

new g_name[] = "hoi_mau"
public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	hide_wpn = get_user_msgid("HideWeapon")
	textmsg = get_user_msgid("SayText")
	
	register_event("ResetHUD", "Event_ResetHUD", "b") 
	register_message( hide_wpn , "Message_HideWeapon") 
	
	mau[HP_25] = bc_qua_register("25 HP", KHAC)
	mau[HP_25_2] = bc_qua_register("25 HP", KHAC)
	mau[HP_50] = bc_qua_register("50 HP", KHAC)
	mau[HP_25_3] = bc_qua_register("25 HP", KHAC)
	mau[HP_75] = bc_qua_register("75 HP", KHAC)
	mau[HP_25_4] = bc_qua_register("25 HP", KHAC)
	mau[HP_100] = bc_qua_register("100 HP", KHAC)
	mau[HP_50_2] = bc_qua_register("50 HP", KHAC)
	mau[HOI] = bc_qua_register("Hoi mau", KHAC)
	mau[HP_25_5] = bc_qua_register("25 HP", KHAC)
	
	new ent = create_entity("info_target") 
	
	if(ent) 
	{ 
		entity_set_string(ent, EV_SZ_classname, g_name) 
		entity_set_float(ent, EV_FL_nextthink, halflife_time() + 0.1) 
	} 
	
	register_think(g_name,"taodangsuynghi")
	
}
public bc_lanhqua_post(id, id_qua) {
	if( id_qua == mau[HP_25] || id_qua == mau[HP_25_2] || id_qua == mau[HP_25_3] || id_qua == mau[HP_25_4] || id_qua == mau[HP_25_5])
	{
		set_user_health(id, get_user_health(id) + 25) 
		client_mau(id, "Da duoc tang them 25 HP")
	}
	else if( id_qua == mau[HP_50] || id_qua == mau[HP_50_2] )
	{
		set_user_health(id, get_user_health(id) + 50) 
		client_mau(id, "Da duoc tang them 50 HP")
	}
	else if( id_qua == mau[HP_75] )
	{
		set_user_health(id, get_user_health(id) + 75) 
		client_mau(id, "Da duoc tang them 75 HP")
	}
	else if( id_qua == mau[HP_100] )
	{
		set_user_health(id, get_user_health(id) + 100) 
		client_mau(id, "Da duoc tang them 100 HP")
	}
	else if( id_qua == mau[HOI] )
	{
		//Set_BitVar(hoimau, id)
		set_task(1.0, "hoi_mau", id + HOIMAUGHE, _, _, "b")
		set_task(30.0, "tat_hoimau", id)
		client_mau(id, "Kich hoat hoi mau trong 30s")
	}
	
}
public hoi_mau(id) {
	id -= HOIMAUGHE
	static hp 
	hp = get_user_health(id)
	if( hp < 100 ) set_user_health(id, hp + 10)
}
public tat_hoimau(id) {
	id += HOIMAUGHE
	if(task_exists(id) ) remove_task(id)
}
public taodangsuynghi(ent) {
	if( is_valid_ent(ent) ) {
		new players[32], iNum
		get_players(players, iNum, "ce","CT")
		for(new i = 0 ; i < iNum; i++) 
		{ 
			purposeless(players[i])
		}
		
		entity_set_float(ent, EV_FL_nextthink, halflife_time() + 0.1) 
	}
}

public purposeless(id) 
{ 
	
	static purpo[64] 
	formatex(purpo, charsmax(purpo), "HP:  %i       |       ARMOR:  %d", get_user_health(id), get_user_armor(id)) 
	
	message_begin(MSG_ONE_UNRELIABLE, SVC_DIRECTOR, _, id); 
	write_byte(strlen(purpo) + 31) 
	write_byte(DRC_CMD_MESSAGE) 
	write_byte(0) 
	write_long(((clamp(65, 0, 255)) + ((clamp(157, 0, 255)) << 8) + ((clamp(216, 0, 255)) << 16))) 
	write_long(_:0.01) 
	write_long(_:0.95) 
	write_long(_:0.1) 
	write_long(_:0.1) 
	write_long(_:0.0) 
	write_long(_:0.0) 
	write_string(purpo) 
	
	message_end() 
} 

public Event_ResetHUD(id) 
{ 
	message_begin(MSG_ONE, hide_wpn, _, id) 
	write_byte((1<<3) | (1<<5)) // them tien thi bo 1<<5
	message_end() 
} 

public Message_HideWeapon() 
{ 
	set_msg_arg_int(1, ARG_BYTE, get_msg_arg_int(1) | (1<<3) | (1<<5)) // them tien thi bo 1<<5
}
/*

public bc_lanhqua_pre(id, id_qua) {
	if ( id_qua == mau[HOI] && Get_BitVar(hoimau, id) )
		return PLUGIN_HANDLED
	return PLUGIN_CONTINUE
}
public bc_progress(progress) {
	if( progress == WAITING)
	{
		new players[32], iNum
		get_players(players, iNum, "ce","CT")
		for(new i = 0 ; i < iNum; i++) 
		{ 
			UnSet_BitVar(hoimau,players[i])
		}
	}
}
public client_disconnect(id) {
	UnSet_BitVar(hoimau,id)
}
public client_connect(id) {
	UnSet_BitVar(hoimau,id)
}*/
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
