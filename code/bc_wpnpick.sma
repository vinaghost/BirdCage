#include <bc_core>

#define PLUGIN "BirdCage: Block pickup weapon"
#define VERSION "1.0"
#define AUTHOR "VINAGHOST"

public plugin_init() {
	
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	RegisterHam(Ham_Touch, "armoury_entity", "FwdHamPickupWeapon")
	RegisterHam(Ham_Touch, "weaponbox", "FwdHamPickupWeapon") 
}
public FwdHamPickupWeapon(ent, id) //block wpn pickup
{
	if(is_alive(id))
	{
		return HAM_SUPERCEDE
	}
	return HAM_IGNORED
}
