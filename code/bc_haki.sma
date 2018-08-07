#include <bc_core>
#include <bc_qua>
#include <xs>

#define PLUGIN "BirdCage: HAKI"
#define VERSION "1.0"
#define AUTHOR "VINAGHOST"

#define DELAY_QUANSAT 20.0
#define DELAY_BAVUONG 50.0

#define XIU 1000
#define MAXLEVEL 6

#define SYNCHUD 3
#define SYNCHUD2 4

enum _:TYPE {
	BAVUONG = 0,
	QUANSAT
}
new bavuong, quansat;
new Spr_Ring,Spr_playerheat
new Float:iAngles[33][3];

//new level[33];
new sound[] = "bc/haki/haki_bavuong.wav"

new p_bavuong, p_quansat

new textmsg 
new Float: g_Cooldown[TYPE][32];
new active
new num[33]
new g_synchud1, g_synchud2


new g_name[] = "haki"
public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	//RegisterHam(Ham_ObjectCaps, "player", "ObjectCaps" );
	
	bavuong = bc_qua_register("HAKI Ba vuong", HAKI)
	quansat = bc_qua_register("HAKI Quan sat", HAKI)
	
	//register_clcmd("say /bavuong", "bat_bavuong");
	//register_clcmd("say /quansat", "bat_quansat");
	
	new ent = create_entity("info_target") 
	
	if(ent) 
	{ 
		entity_set_string(ent, EV_SZ_classname, g_name) 
		entity_set_float(ent, EV_FL_nextthink, halflife_time() + 1.0) 
	} 
	register_think(g_name,"taodangsuynghi")
	
	textmsg = get_user_msgid("SayText")
	g_synchud1 = CreateHudSyncObj(SYNCHUD)
	g_synchud2 = CreateHudSyncObj(SYNCHUD2)
}
public plugin_precache() {
	Spr_Ring = precache_model("sprites/shockwave.spr")
	Spr_playerheat = precache_model("sprites/poison.spr")
	
	precache_sound(sound);
}
public bc_lanhqua_pre(id, id_qua) {
	if( id_qua == bavuong || id_qua == quansat)
		if( num[id] > 1)	return PLUGIN_HANDLED
	
	return PLUGIN_CONTINUE
}
public bc_lanhqua_post(id, id_qua) {
	if( id_qua == bavuong)
		bat_bavuong(id)
	else if( id_qua == quansat)
		bat_quansat(id)
}
public bc_use_post(id) {
	if( num[id] < 2)
	{
		if ( Get_BitVar(p_bavuong, id) ) haki_bavuong(id)
		else if ( Get_BitVar(p_quansat, id)) haki_quansat(id)
		}
	else 
	{
		new menu = menu_create("\r[Lồng chim] \yChọn Haki", "choose_menu")
		menu_additem( menu, "QUAN SAT")
		menu_additem( menu, "BA VUONG")
		menu_setprop( menu, MPROP_NUMBER_COLOR, "\r" );
		menu_setprop( menu, MPROP_EXITNAME, "Thoát" );
		menu_display( id, menu );
	}
	return PLUGIN_CONTINUE;
}
public bc_progress(progress) {
	if( progress == WAITING )
	{
		new players[32], iNum
		get_players(players, iNum, "ce","CT")
		for(new i = 0 ; i < iNum; i++) 
		{ 
			remove_haki(players[i])
		}
		
	}
}
public bat_bavuong(id) {
	Set_BitVar(p_bavuong, id)
	num[id]++
	
}
public bat_quansat(id) {
	Set_BitVar(p_quansat, id)
	num[id]++
}
remove_haki(id) {
	UnSet_BitVar(p_bavuong, id)
	UnSet_BitVar(p_quansat, id)
	num[id] = 0
}
public choose_menu(id, menu, item) {
	if( !is_alive(id) ) return;
	switch (item) 
	{
		case 0: haki_quansat(id)
			case 1: haki_bavuong(id)
		}
	menu_destroy(menu)
}
public haki_bavuong(id)
{
	if(!is_alive(id)) return;
	
	if(!Get_BitVar(p_bavuong,id)) return;
	
	static Float: gametime ; gametime = get_gametime();
	if(gametime - DELAY_BAVUONG < g_Cooldown[BAVUONG][id]) return 
	g_Cooldown[BAVUONG][id] = gametime;
	
	new iplayers[32],plrn;
	get_players( iplayers, plrn, "ae","CT");
	
	new Float:origin1[3],Float:origin2[3];
	new Float:distance;
	pev(id,pev_origin,origin1);
	ring(origin1, id);
	
	emit_sound(id, CHAN_VOICE, sound, 1.0, ATTN_NONE, 0, PITCH_NORM)
	
	for(new i = 0; i < plrn; i++)
	{
		if(iplayers[i] == id) 
			continue;
		
		pev(iplayers[i],pev_origin,origin2);
		distance = get_distance_f(origin1,origin2);
		
		if(distance <= 1000)
		{
			choang(iplayers[i]);
			xiu(iplayers[i]);	
			set_task(5.0,"xiulen",XIU+iplayers[i]);
			emit_sound(iplayers[i], CHAN_VOICE, sound, 1.0, ATTN_NONE, 0, PITCH_NORM)
			//client_print(iplayers[i],print_chat,"Ban dang bi choang va xiu do HAKI ba vuong")
		}
	}
	
	
}
public haki_quansat(id) {
	if(!is_alive(id)) return;
	if(!Get_BitVar(p_quansat,id)) return;
	static Float: gametime ; gametime = get_gametime();
	if(gametime - DELAY_QUANSAT < g_Cooldown[QUANSAT][id]) return 
	g_Cooldown[QUANSAT][id] = gametime;
	
	Set_BitVar(active, id)
	set_task(10.0, "deactive", id)
}

public show(id)
{
	if(get_progress() != START) return
	if(!is_alive(id)) return
	static Float: gametime ; gametime = get_gametime();
	if( num[id] < 2)
	{
		if ( Get_BitVar(p_bavuong, id) ) 
		{
			if(gametime - DELAY_BAVUONG > g_Cooldown[BAVUONG][id])
			{
				set_hudmessage(0,255, 0, 0.0, 0.10, 0, 1.0, 1.0) // xanh la cay
				ShowSyncHudMsg(id, g_synchud1, "[E] HAKI Bá vương - SẴN SÀNG")
			}
			else 
			{					
				set_hudmessage(255,0, 0, 0.0, 0.10, 0, 1.0, 1.0) // do
				ShowSyncHudMsg(id, g_synchud1, "[E] HAKI Bá vương - CHƯA SẴN SÀNG")
			}
		}
		
		else if ( Get_BitVar(p_quansat, id)) 
		{
			if(gametime - DELAY_QUANSAT > g_Cooldown[QUANSAT][id])
			{
				set_hudmessage(0, 255, 0, 0.0, 0.10, 0, 1.0, 1.0) // xanh la cay
				ShowSyncHudMsg(id, g_synchud1, "[E] HAKI Quan sát - SẴN SÀNG")
			}
			else if( Get_BitVar(active, id) )
			{					
				set_hudmessage(0, 0, 255, 0.0, 0.10, 0, 1.0, 1.0) // xanh duong
				ShowSyncHudMsg(id, g_synchud1, "[E] HAKI Quan sát - ĐANG ĐƯỢC SỬ DỤNG")
			}
			else 
			{
				set_hudmessage(255, 0, 0, 0.0, 0.10, 0, 1.0, 1.0) //do 
				ShowSyncHudMsg(id, g_synchud1, "[E] HAKI Quan sát - CHƯA SẴN SÀNG")
			}
		}
	}
	else 
	{
		if(gametime - DELAY_BAVUONG > g_Cooldown[BAVUONG][id])
		{
			set_hudmessage(0,255, 0, 0.0, 0.10, 0, 1.0, 1.0) // xanh la cay
			ShowSyncHudMsg(id, g_synchud1, "[E] HAKI Bá vương - SẴN SÀNG")
		}
		else 
		{					
			set_hudmessage(255,0, 0, 0.0, 0.10, 0, 1.0, 1.0) // do
			ShowSyncHudMsg(id, g_synchud1, "[E] HAKI Bá vương - CHƯA SẴN SÀNG")
		}
		if(gametime - DELAY_QUANSAT > g_Cooldown[QUANSAT][id])
		{
			set_hudmessage(0, 255, 0, 0.0, 0.13, 0, 1.0, 1.0) // xanh la cay
			ShowSyncHudMsg(id, g_synchud2, "[E] HAKI Quan sát - SẴN SÀNG")
		}
		else if( Get_BitVar(active, id) )
		{					
			set_hudmessage(0, 0, 255, 0.0, 0.13, 0, 1.0, 1.0) // xanh duong
			ShowSyncHudMsg(id, g_synchud1, "[E] HAKI Quan sát - ĐANG ĐƯỢC SỬ DỤNG")
		}
		else 
		{
			set_hudmessage(255, 0, 0, 0.0, 0.13, 0, 1.0, 1.0) //do 
			ShowSyncHudMsg(id, g_synchud1, "[E] HAKI Quan sát - CHƯA SẴN SÀNG")
		}
	}	
}
public client_PostThink(id)
{
	if(!is_alive(id)) return PLUGIN_CONTINUE
	if(!p_quansat) return PLUGIN_CONTINUE
	if(!Get_BitVar(active, id)) return PLUGIN_CONTINUE
	
	new Float:fMyOrigin[3]
	entity_get_vector(id, EV_VEC_origin, fMyOrigin)
	
	static Players[32], iNum
	get_players(Players, iNum, "ae", "CT")
	for(new i = 0; i < iNum; ++i) if(id != Players[i]) {
		new target = Players[i]
		
		new Float:fTargetOrigin[3]
		entity_get_vector(target, EV_VEC_origin, fTargetOrigin)
		
		if((get_distance_f(fMyOrigin, fTargetOrigin) > 1000) 
		|| !is_in_viewcone(id, fTargetOrigin))
		continue
		
		new Float:fMiddle[3], Float:fHitPoint[3]
		xs_vec_sub(fTargetOrigin, fMyOrigin, fMiddle)
		trace_line(-1, fMyOrigin, fTargetOrigin, fHitPoint)
		
		new Float:fWallOffset[3], Float:fDistanceToWall
		fDistanceToWall = vector_distance(fMyOrigin, fHitPoint) - 10.0
		normalize(fMiddle, fWallOffset, fDistanceToWall)
		
		new Float:fSpriteOffset[3]
		xs_vec_add(fWallOffset, fMyOrigin, fSpriteOffset)
		new Float:fScale, Float:fDistanceToTarget = vector_distance(fMyOrigin, fTargetOrigin)
		if(fDistanceToWall > 100.0)
			fScale = 8.0 * (fDistanceToWall / fDistanceToTarget)
		else
			fScale = 2.0
		
		te_sprite(id, fSpriteOffset, Spr_playerheat, floatround(fScale), 125)
	}
	return PLUGIN_CONTINUE
}
public xiulen(id) {
	id=id-XIU
	hetxiu(id)
}
public client_disconnect(id) {
	remove_haki(id)
}
public client_connect(id) {
	remove_haki(id)
}

stock choang(id) {
	new Float: fl_Angle[3];
	for(new i = 0 ; i < 3 ; i++)
		fl_Angle[i] = random_float(-100.0, 100.0);
	
	entity_set_vector(id, EV_VEC_punchangle, fl_Angle);
}
stock xiu(id) { 
	new iFlags = pev( id , pev_flags );
	
	if( ~iFlags & FL_FROZEN ) 
	{ 
		set_pev( id , pev_flags , iFlags | FL_FROZEN );
		pev( id , pev_v_angle , iAngles[ id ] );
	} 
}
public hetxiu(id) { 
	new iFlags = pev( id , pev_flags ) ;
	
	if( iFlags & FL_FROZEN ) 
	{ 
		set_pev( id , pev_flags , iFlags & ~FL_FROZEN )
	}
} 
public ring(const Float:origin[3], id) {
	
	engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, origin, 0)
	write_byte(TE_BEAMCYLINDER) // TE id
	engfunc(EngFunc_WriteCoord, origin[0]) // x
	engfunc(EngFunc_WriteCoord, origin[1]) // y
	engfunc(EngFunc_WriteCoord, origin[2]) // z
	engfunc(EngFunc_WriteCoord, origin[0]) // x axis
	engfunc(EngFunc_WriteCoord, origin[1]) // y axis
	engfunc(EngFunc_WriteCoord, origin[2]+ 1000) 
	write_short(Spr_Ring) // sprite
	write_byte(0) // startframe
	write_byte(0) // framerate
	write_byte(4) // life
	write_byte(60) // width
	write_byte(0) // noise
	write_byte(0) // red
	write_byte(255) // green
	write_byte(255) // blue
	write_byte(150) // brightness
	write_byte(0) // speed
	message_end()
	
}
public deactive(id) {
	UnSet_BitVar(active, id)
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
stock te_sprite(id, Float:origin[3], sprite, scale, brightness)
{
	message_begin(MSG_ONE, SVC_TEMPENTITY, _, id)
	write_byte(TE_SPRITE)
	write_coord(floatround(origin[0]))
	write_coord(floatround(origin[1]))
	write_coord(floatround(origin[2]))
	write_short(sprite)
	write_byte(scale) 
	write_byte(brightness)
	message_end()
}

stock normalize(Float:fIn[3], Float:fOut[3], Float:fMul)
{
	new Float:fLen = xs_vec_len(fIn)
	xs_vec_copy(fIn, fOut)
	
	fOut[0] /= fLen, fOut[1] /= fLen, fOut[2] /= fLen
	fOut[0] *= fMul, fOut[1] *= fMul, fOut[2] *= fMul
}
public taodangsuynghi(ent) {
	if( is_valid_ent(ent)) 
	{
		if(get_progress() == START)
		{
			
			new players[32], iNum
			get_players(players, iNum, "ce","CT")
			for(new i = 0 ; i < iNum; i++) 
			{ 
				show(players[i])
			}
		}
		
		entity_set_float(ent, EV_FL_nextthink, halflife_time() + 1.0) 
	}
}
