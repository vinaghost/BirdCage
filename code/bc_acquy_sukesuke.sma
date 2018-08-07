#include <bc_core>
#include <bc_qua>
#include <bc_traiacquy>

#define PLUGIN "BirdCage: Suke Suke no mi"
#define VERSION "1.0"
#define AUTHOR "VINAGHOST"

new acquy, active
public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	register_event("CurWeapon","CurWeapon","be")
	
	acquy = bc_acquy_register("Suke Suke", 40, 15, PARAMECIA)
}
public bc_taq_kichhoat(id, id_trai) {
	if (id_trai == acquy)
		Set_BitVar(active,id)
}
public bc_taq_end(id, id_trai) {
	if (id_trai == acquy)
		UnSet_BitVar(active, id)
}


public client_PreThink(id) {
	if ( Get_BitVar(active, id) )
		set_user_rendering(id, kRenderFxNone, 0, 0, 0, kRenderTransTexture, 0)
	else 
		set_user_rendering(id, kRenderFxNone, 0, 0, 0, kRenderNormal, 0)
}
public bc_curwpn(id) {
	if ( Get_BitVar(active, id) )
	{
		bc_qua_custom_hand(id, 1)
		set_pev(id, pev_viewmodel, 0)
	}
	else 
		bc_qua_custom_hand(id, 0)
	return PLUGIN_CONTINUE
}
public CurWeapon(id) {
	if(!is_alive(id))
		return PLUGIN_CONTINUE
	
	
	new iClip, iAmmo, iWeap = get_user_weapon(id,iClip,iAmmo)
	if(iWeap == CSW_KNIFE)
	{
		
		if ( Get_BitVar(active, id) )
		{
			bc_qua_custom_hand(id, 1)
			set_pev(id, pev_viewmodel, 0)
		}
		else 
			bc_qua_custom_hand(id, 0)
	}
	
	return PLUGIN_CONTINUE
}
