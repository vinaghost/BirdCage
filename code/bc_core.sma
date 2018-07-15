#include <amxmodx>
#include <amxmisc>
#include <engine>
#include <hamsandwich>
#include <fakemeta>
#include <fakemeta_stocks>
#include <cstrike>
#include <fun>

#define PLUGIN "BirdCage: CORE"
#define VERSION "1.0"
#define AUTHOR "VINAGHOST"

// Bits
#define Get_BitVar(%1,%2)		(%1 & (1 << (%2 & 31)))
#define Set_BitVar(%1,%2)		(%1 |= (1 << (%2 & 31)));
#define UnSet_BitVar(%1,%2)		(%1 &= ~(1 << (%2 & 31)));


new g_HamBot
new g_IsConnected, g_IsAlive
new g_progress

#define OFFSET_TEAM	114
#define fm_get_user_team(%1)	get_pdata_int(%1,OFFSET_TEAM)
#define fm_set_user_team(%1,%2)	set_pdata_int(%1,OFFSET_TEAM,%2)

enum _:TOTAL_FORWARDS {
	PROGRESS,
	USE_BUTTON_PRE,
	USE_BUTTON_POST,
	LAST
}

new g_forward[TOTAL_FORWARDS]
new g_ForwardResult

new g_LastForwardCalled 
//new g_name[] = "alo"
enum _: {
	WAITING = 0,
	COUNTDOWN,
	START
}
new g_iMaxPlayers, textmsg, gmsgRadar
public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	RegisterHam(Ham_Spawn,"player","fw_Spawn_Post", 1);
	RegisterHam(Ham_Killed, "player", "fw_Killed_Post", 1)
	//RegisterHam(Ham_TakeDamage, "player", "fw_Takedmg_Post", 1)
	
	RegisterHam(Ham_TraceAttack, "player", "TraceAttack")
	RegisterHam(Ham_TakeDamage, "player", "TakeDamage")
	RegisterHam(Ham_Killed, "player", "Killed")
	RegisterHam(Ham_ObjectCaps, "player", "ObjectCaps", 1 );
	
	register_event("HLTV", "Event_NewRound", "a", "1=0", "2=0");
	
	g_forward[PROGRESS] = CreateMultiForward("bc_progress", ET_IGNORE, FP_CELL)
	g_forward[LAST] = CreateMultiForward("bc_last", ET_IGNORE, FP_CELL)
	g_forward[USE_BUTTON_PRE] = CreateMultiForward("bc_use_pre", ET_IGNORE, FP_CELL)
	g_forward[USE_BUTTON_POST] = CreateMultiForward("bc_use_post", ET_IGNORE, FP_CELL)
	//g_forward[TAKE_DMG] = CreateMultiForward("bc_takedmg", ET_IGNORE, FP_CELL, FP_CELL, FP_FLOAT)
	textmsg = get_user_msgid("SayText")
	g_iMaxPlayers = get_maxplayers()
	g_progress = WAITING
	//server_print("%d", g_progress ? 1 : 0)
	
	register_clcmd("say /count", "dem")
	
	/*new ent = create_entity("info_target") 
	
	if(ent) 
	{ 
		entity_set_string(ent, EV_SZ_classname, g_name) 
		entity_set_float(ent, EV_FL_nextthink, halflife_time() + 0.1) 
	} 
	register_think(g_name,"taodangsuynghi")*/
	gmsgRadar = get_user_msgid("Radar")
	register_message( gmsgRadar, "Message_Radar")
}
public plugin_natives() {
	
	register_native("is_alive","is_alive", 1)
	register_native("is_connected","is_connected", 1)
	register_native("get_progress","get_progress", 1)
	register_native("set_progress","set_progress", 1)
		
	// register_native("client_mau", "client_mau" , 1)
}
public client_putinserver(id) {	
	if(!g_HamBot && is_user_bot(id))
	{
		g_HamBot = 1
		set_task(0.1, "Register_HamBot", id)
	}
		
	Safety_Connected(id)
}
public client_disconnect(id) Safety_Disconnected(id)

public Safety_Connected(id) {
	Set_BitVar(g_IsConnected, id)
	UnSet_BitVar(g_IsAlive, id)
}
public Event_NewRound() {
	 set_progress(WAITING)
}

public Safety_Disconnected(id) {
	UnSet_BitVar(g_IsConnected, id)
	UnSet_BitVar(g_IsAlive, id)
	CheckLast()
}

public Register_HamBot(id) {
	RegisterHamFromEntity(Ham_Spawn, id, "fw_Spawn_Post", 1)
	//RegisterHamFromEntity(Ham_Spawn, id, "HamSpawn", 1)
	RegisterHamFromEntity(Ham_Killed, id, "fw_Killed_Post", 1)
	//RegisterHamFromEntity(Ham_TakeDamage, id, "fw_Takedmg_Post", 1)
	//RegisterHamFromEntity(Ham_TraceAttack, id, "fw_TraceAttack")
}
public is_connected(id) {
	if(!((0 < id) && (id < g_iMaxPlayers + 1)))
		return 0;
	if(!Get_BitVar(g_IsConnected, id))
		return 0;
	
	return 1;
}

public is_alive(id) {
	if(!is_connected(id))
		return 0;
	if(!Get_BitVar(g_IsAlive, id))
		return 0;
	
	return 1;
}
public get_progress() {
	return g_progress;
}
public set_progress(progress) {
	if( progress < 0 || progress > 2)
		server_print("[ERROR] SET PROGRESS: %d", progress)
	else
	{
		g_progress = progress
		ExecuteForward(g_forward[PROGRESS], g_ForwardResult, g_progress)
	}
}
/*
public fw_Takedmg_Post(victim, inflictor, attacker, Float:damage, bits ) {
	if(!is_connected(victim) || !is_connected(attacker) || victim == attacker) return
	
	ExecuteForward(g_forward[PROGRESS], g_ForwardResult, victim , attacker, damage)
}*/
public fw_Killed_Post(id) {
	
	UnSet_BitVar(g_IsAlive, id)
	CheckLast()
}
public taodangsuynghi(Ent)
{
	/*if (g_progress == START)
		CheckLast()*/
	entity_set_float(Ent,EV_FL_nextthink, 1.0)
}
public fw_Spawn_Post(id) {
	if(is_user_alive(id) && get_user_team(id) == 2)
		Set_BitVar(g_IsAlive, id)
}
public TraceAttack(victim, attacker, Float:damage, Float:direction[3], tracehandle, damagebits)
{
	if( !g_progress ) return HAM_IGNORED
	if( victim != attacker && (1 <= attacker <= g_iMaxPlayers) )
	{
		new vteam = fm_get_user_team(victim)
		if( vteam == fm_get_user_team(attacker) )
		{
			fm_set_user_team(victim, vteam == 1 ? 2 : 1)
			ExecuteHamB(Ham_TraceAttack, victim, attacker, damage, direction, tracehandle, damagebits)
			fm_set_user_team(victim, vteam)
			return HAM_SUPERCEDE
		}
	}
	return HAM_IGNORED
}

public TakeDamage(victim, idinflictor, attacker, Float:damage, damagebits)
{
	if( !g_progress ) return HAM_IGNORED
	if( victim != attacker && (1 <= attacker <= g_iMaxPlayers) )
	{
		new vteam = fm_get_user_team(victim)
		if( vteam == fm_get_user_team(attacker) )
		{
			fm_set_user_team(victim, vteam == 1 ? 2 : 1)
			ExecuteHamB(Ham_TakeDamage, victim, idinflictor, attacker, damage, damagebits)
			fm_set_user_team(victim, vteam)
			return HAM_SUPERCEDE
		}
	}
	return HAM_IGNORED
}

public Killed(victim, attacker, shouldgib)
{
	if( !g_progress ) return HAM_IGNORED
	if( victim != attacker && (1 <= attacker <= g_iMaxPlayers) )
	{
		new vteam = fm_get_user_team(victim)
		if( vteam == fm_get_user_team(attacker) )
		{
			fm_set_user_team(victim, vteam == 1 ? 2 : 1)
			ExecuteHamB(Ham_Killed, victim, attacker, shouldgib)
			fm_set_user_team(victim, vteam)
			return HAM_SUPERCEDE
		}
	}
	return HAM_IGNORED
}
public ObjectCaps(id) {
	if(!is_alive(id))
		return;

	if(get_user_button(id) & IN_USE)
	{	
		ExecuteForward(g_forward[USE_BUTTON_PRE], g_ForwardResult, id)
		if (g_ForwardResult > PLUGIN_CONTINUE)
			return;
		ExecuteForward(g_forward[USE_BUTTON_POST], g_ForwardResult, id)
	}
}
	
public Count() {
	new players[32]
	new amount
	get_players(players, amount, "ae", "CT")
	
	return amount;
}
public dem() {
	client_mau(0, "So nguoi: %d" , Count() )
}
public CheckLast()
{
	new id, last_id
	
	if (Count() == 1)
	{
		for (id = 1; id <= g_iMaxPlayers; id++)
		{
			if ( Get_BitVar(g_IsAlive, id))
			{
				last_id = id
			}
		}
	}
	else
		g_LastForwardCalled  = false;
	
	if (last_id > 0 && !g_LastForwardCalled)
	{
		client_mau(0, "Đã xuất hiện người trụ lại cuối cùng")
		ExecuteForward(g_forward[LAST], g_ForwardResult, last_id)
		g_LastForwardCalled = true
		
	}
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
public Message_Radar(iMsgId, MSG_DEST, id)
{
	return PLUGIN_HANDLED
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
