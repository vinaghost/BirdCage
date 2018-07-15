#include <bc_core>

#define PLUGIN "BirdCage: SEMICLIP"
#define VERSION "1.0"
#define AUTHOR "VINAGHOST"

new bool:g_isSolid[33]
new bool:g_isSemiClip[33]
new g_iPlayers[32], g_iNum, g_iPlayer

public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	register_forward(FM_PlayerPreThink, "fw_PlayerPreThink");
	register_forward(FM_PlayerPostThink, "fw_PlayerPostThink");
	register_forward(FM_AddToFullPack, "fw_addToFullPack", 1)
}
public fw_PlayerPreThink(id)
{
	if (!is_alive(id) || get_progress())
		return FMRES_IGNORED
	
		
	get_players(g_iPlayers, g_iNum, "ache","CT")
	
	static i
	for (i = 0; i < g_iNum; i++)
	{
		g_iPlayer = g_iPlayers[i]
		if (!g_isSemiClip[g_iPlayer])
			g_isSolid[g_iPlayer] = true
		else
			g_isSolid[g_iPlayer] = false
	}
	
	if (g_isSolid[id])
	for (i = 0; i < g_iNum; i++)
	{
		g_iPlayer = g_iPlayers[i]
		
		if (!g_isSolid[g_iPlayer] || g_iPlayer == id )
			continue
			
		set_pev(g_iPlayer, pev_solid, SOLID_NOT)
		g_isSemiClip[g_iPlayer] = true
	}
		
	return FMRES_IGNORED	
}

public fw_PlayerPostThink(id)
{
	if (!is_alive(id) || get_progress())
		return FMRES_IGNORED
	
	get_players(g_iPlayers, g_iNum, "ache","CT")
	
	static i
	for (i = 0; i < g_iNum; i++)
	{
		g_iPlayer = g_iPlayers[i]
		if (g_isSemiClip[g_iPlayer])
		{
			set_pev(g_iPlayer, pev_solid, SOLID_SLIDEBOX)
			g_isSemiClip[g_iPlayer] = false
		}
	}
	
	return FMRES_IGNORED
}

public fw_addToFullPack(es, e, ent, host, hostflags, player, pSet)
{
	if ( !player )
		return FMRES_SUPERCEDE;
		
	if(player)
	{
		if (!is_alive(host) || !g_isSolid[host] || get_progress())
			return FMRES_IGNORED
			
		set_es(es, ES_Solid, SOLID_NOT)
	}
	return FMRES_IGNORED
}
