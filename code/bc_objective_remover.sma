#include <bc_core>

#define PLUGIN "BirdCage: OBJECTIVE REMOVER"
#define VERSION "1.0"
#define AUTHOR "VINAGHOST"

new const g_objective_ents[][] = {
	"func_bomb_target",
	"info_bomb_target",
	"hostage_entity",
	"monster_scientist",
	"func_hostage_rescue",
	"info_hostage_rescue",
	"info_vip_start",
	"func_vip_safetyzone",
	"func_escapezone",
	"info_map_parameters",
	"func_buyzone"
}
new const g_szBotName[ ] = "Donquixote Doflamingo";
public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	register_message(107, "StatusIcon")
	new iEntity = create_entity( "info_map_parameters" );
	
	DispatchKeyValue( iEntity, "buying", "3" );
	DispatchSpawn( iEntity );
	
	set_task(10.0, "UpdateBot")
}
public pfn_spawn(entid)
{
	if(!is_valid_ent(entid)) return PLUGIN_CONTINUE
	static classname[32], i
	entity_get_string(entid,EV_SZ_classname,classname,charsmax(classname))
	
	for (i = 0; i < sizeof g_objective_ents; ++i) {
		if (equal(classname, g_objective_ents[i])) {
			
			remove_entity(entid)
			return PLUGIN_HANDLED
		}
	}
	return PLUGIN_CONTINUE
}
public StatusIcon(msg, dest, id) {
	new icon[8]; get_msg_arg_string(2, icon, 7);
	
	if(equal(icon, "buyzone") && get_msg_arg_int(1)) {
		set_pdata_int(id, 235, get_pdata_int(id, 235) & ~(1<<0));
		return 1;
	}
	return 0;
}/*
public bc_progress(progress) {
	if ( progress == COUNTDOWN )
		UpdateBot()
	else if (progress == WAITING )
	{		
		server_cmd("kick ^"%s^"", g_szBotName);
	}
}*/
public UpdateBot( ) {
	
	new id = find_player( "ai",  g_szBotName);
	
	if( !id ) {
		id = engfunc( EngFunc_CreateFakeClient, g_szBotName );
		if( pev_valid( id ) ) {
			engfunc( EngFunc_FreeEntPrivateData, id );
			dllfunc( MetaFunc_CallGameEntity, "player", id );
			set_user_info( id, "rate", "3500" );
			set_user_info( id, "cl_updaterate", "25" );
			set_user_info( id, "cl_lw", "1" );
			set_user_info( id, "cl_lc", "1" );
			set_user_info( id, "cl_dlmax", "128" );
			set_user_info( id, "cl_righthand", "1" );
			set_user_info( id, "_vgui_menus", "0" );
			set_user_info( id, "_ah", "0" );
			set_user_info( id, "dm", "0" );
			set_user_info( id, "tracker", "0" );
			set_user_info( id, "friends", "0" );
			set_user_info( id, "*bot", "1" );
			set_pev( id, pev_flags, pev( id, pev_flags ) | FL_FAKECLIENT );
			set_pev( id, pev_colormap, id );
			
			new szMsg[ 128 ];
			dllfunc( DLLFunc_ClientConnect, id, g_szBotName, "127.0.0.1", szMsg );
			dllfunc( DLLFunc_ClientPutInServer, id );
			
			cs_set_user_team( id, CS_TEAM_T );
			ExecuteHamB( Ham_CS_RoundRespawn, id );
			entity_set_origin( id, Float:{ 999999.0, 999999.0, 999999.0 } );
			set_pev( id, pev_effects, pev( id, pev_effects ) | EF_NODRAW );
			set_pev( id, pev_solid, SOLID_NOT );
			dllfunc( DLLFunc_Think, id );
		}
	}
}
