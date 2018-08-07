#include <bc_core>

#define PLUGIN "BirdCage: QUA"
#define VERSION "1.0"
#define AUTHOR "VINAGHOST"

#define MAX_KNIFE_SNDS 9

new knife_sounds_o[MAX_KNIFE_SNDS][] = {
	"weapons/knife_deploy1.wav",
	"weapons/knife_hit1.wav",
	"weapons/knife_hit2.wav",
	"weapons/knife_hit3.wav",
	"weapons/knife_hit4.wav",
	"weapons/knife_hitwall1.wav",
	"weapons/knife_slash1.wav",
	"weapons/knife_slash2.wav",
	"weapons/knife_stab.wav"
}

new knife_sounds_r[MAX_KNIFE_SNDS][] = {
	"bc/weapons/knife_deploy1.wav",
	"bc/weapons/knife_hit1.wav",
	"bc/weapons/knife_hit2.wav",
	"bc/weapons/knife_hit3.wav",
	"bc/weapons/knife_hit4.wav",
	"bc/weapons/knife_hitwall1.wav",
	"bc/weapons/knife_slash1.wav",
	"bc/weapons/knife_slash2.wav",
	"bc/weapons/knife_stab.wav"
}
new hand_models[][] = {
	"models/bc/weapons/v_hand.mdl",
	"models/bc/weapons/p_hand.mdl"
}

new Array:g_Name, Array:g_Type
new g_Count

enum _: {
	HAKI = 0,
	TRAIACQUY,
	KHAC
}
enum _:TOTAL_FORWARDS {
	PRE,
	POST
}
new g_qua[TOTAL_FORWARDS]
new g_ForwardResult

new textmsg
new h_custom
public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	register_event("CurWeapon","CurWeapon","be")
	register_forward(FM_EmitSound , "EmitSound");
	
	textmsg = get_user_msgid("SayText")
	g_qua[PRE] = CreateMultiForward("bc_lanhqua_pre", ET_IGNORE, FP_CELL, FP_CELL)
	g_qua[POST] = CreateMultiForward("bc_lanhqua_post", ET_IGNORE, FP_CELL, FP_CELL)
}
public plugin_precache()  {
	new i
	for( i = 0; i < MAX_KNIFE_SNDS; i++)
		precache_sound(knife_sounds_r[i]);
	for( i = 0; i < 2; i++)
		precache_model(hand_models[i])
	
}
public plugin_natives()
{
	register_native("bc_qua_register", "bc_qua_register")
	register_native("bc_qua_random", "bc_qua_random", 1)
	register_native("bc_qua_custom_hand", "bc_qua_custom_hand")
	g_Name = ArrayCreate(32, 1)
	g_Type = ArrayCreate(1, 1)
}

public bc_progress(progress) {
	if( progress == COUNTDOWN )
		h_custom = 0
}
public CurWeapon(id) {
	if(!is_alive(id))
		return PLUGIN_CONTINUE
	
		
	new iClip, iAmmo, iWeap = get_user_weapon(id,iClip,iAmmo)
	if(iWeap == CSW_KNIFE)
	{
		
		if(!Get_BitVar(h_custom,id)) 
			entity_set_string(id,EV_SZ_viewmodel,hand_models[0])
			
		entity_set_string(id,EV_SZ_weaponmodel,hand_models[1])
	}
	
	return PLUGIN_CONTINUE
}
public EmitSound(entity, channel, const sound[]) {
	if(pev_valid(entity) && is_alive(entity)) 
	{
		for(new i = 0; i < MAX_KNIFE_SNDS; i++) 
		{
			if(equal(sound , knife_sounds_o[i])) 
			{
				emit_sound(entity, channel, knife_sounds_r[i], 1.0, ATTN_NORM, 0, PITCH_NORM);
				return FMRES_SUPERCEDE;
			}
		}
	}
	return FMRES_IGNORED;
}
public bc_qua_random(id) {
	
	new qua = random_num(0, g_Count - 1)
		
	ExecuteForward(g_qua[PRE], g_ForwardResult, id, qua)
	
	if (g_ForwardResult > PLUGIN_CONTINUE) return
	
	ExecuteForward(g_qua[POST], g_ForwardResult, id, qua)
}
public bc_qua_register(plugin_id, num_params) {
	new name[32]
	get_string(1, name, charsmax(name))
	
	ArrayPushString(g_Name, name)
	
	new type = get_param(2)
	ArrayPushCell(g_Type, type)
	
	g_Count++
	return g_Count - 1;
}
public bc_qua_custom_hand(plugin_id, num_params) {
	if( get_param(2) )
		Set_BitVar(h_custom,get_param(1))
	else
		UnSet_BitVar(h_custom,get_param(1))
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
