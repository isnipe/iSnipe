#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

//Extra dvar changes go in here

Dvars()
{
    self SetClientDvar( "lowAmmoWarningColor1", "0 0 0 0" );
    self SetClientDvar( "lowAmmoWarningColor2", "0 0 0 0" );
    self SetClientDvar( "lowAmmoWarningNoAmmoColor1", "0 0 0 0" );
    self SetClientDvar( "lowAmmoWarningNoAmmoColor2", "0 0 0 0" );
    self SetClientDvar( "lowAmmoWarningNoReloadColor1", "0 0 0 0" );
    self SetClientDvar( "lowAmmoWarningNoReloadColor2", "0 0 0 0" );

    setDvar("perk_weapSpreadMultiplier", 0.45);
    setDvar("perk_fastSnipeScale", 3);
    setDvar("cl_maxpackets", 100); //Improve ping
    setDvar("cg_drawBreathHint", 0); //Show 'hold /shift/ to steady' hint while scoping
}
 