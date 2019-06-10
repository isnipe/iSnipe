#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

InitAntiCamp(MaxCampTime)
{

if (level.anticampinitialized != 1)
{
level.anticampinitialized = 1;
level.campers = [];
level.campers[1] = "";
level.campers[2] = "";
level.campers[3] = "";
level.campers[4] = "";
level.campers[5] = "";
self.campernumber = 0;
level.camperstimeleft = [];
}
self thread DoHUD();
self thread maps\mp\isnipe\extras\anticamp::RemoveSelfFromListOnDeath();
self maps\mp\isnipe\extras\anticamp::EnableAntiCamp(MaxCampTime);

}

DoHUD()
{
self endon("death");

campers = self createFontString("hud", 1);
campers setPoint("CENTERLEFT", "CENTERLEFT", 10, -25);

camperone = self createFontString("hud", 0.9);
camperone setPoint("CENTERLEFT", "CENTERLEFT", 10, -15);

campertwo = self createFontString("hud", 0.9);
campertwo setPoint("CENTERLEFT", "CENTERLEFT", 10, -5);

camperthree = self createFontString("hud", 0.9);
camperthree setPoint("CENTERLEFT", "CENTERLEFT", 10, 5);

camperfour = self createFontString("hud", 0.9);
camperfour setPoint("CENTERLEFT", "CENTERLEFT", 10, 15);

camperfive = self createFontString("hud", 0.9);
camperfive setPoint("CENTERLEFT", "CENTERLEFT", 10, 25);

campers setText("");

self thread deleteondeath(campers);
self thread deleteondeath(camperone);
self thread deleteondeath(campertwo);
self thread deleteondeath(camperthree);
self thread deleteondeath(camperfour);
self thread deleteondeath(camperfive);

campers.hideWhenInMenu = true;
camperone.hideWhenInMenu = true;
campertwo.hideWhenInMenu = true;
camperthree.hideWhenInMenu = true;
camperfour.hideWhenInMenu = true;
camperfive.hideWhenInMenu = true;

for(;;)
{

if (level.camperstimeleft[1] == "" && level.camperstimeleft[2] == "" && level.camperstimeleft[3] == "" && level.camperstimeleft[4] == "" && level.camperstimeleft[5] == "")
{
campers setText("");
} else {
campers setText("^1ANTICAMP");
}


if (level.camperstimeleft[1] == "")
{
camperone setText("");

} else {
camperone setText(level.campers[1] + " ^3(" + level.camperstimeleft[1] + ")");
}

if (level.camperstimeleft[2] == "")
{
campertwo setText("");
} else {
campers setText("^1ANTICAMP");
campertwo setText(level.campers[2] + " ^3(" + level.camperstimeleft[2] + ")");
}

if (level.camperstimeleft[3] == "")
{
camperthree setText("");
} else {
camperthree setText(level.campers[3] + " ^3(" + level.camperstimeleft[3] + ")");
}

if (level.camperstimeleft[4] == "")
{
camperfour setText("");

} else {
camperfour setText(level.campers[4] + " ^3(" + level.camperstimeleft[4] + ")");
}

if (level.camperstimeleft[5] == "")
{
camperfive setText("");

} else {
camperfive setText(level.campers[5] + " ^3(" + level.camperstimeleft[5] + ")");
}

wait 0.1;
}

}

deleteondeath(hud)
{
        self waittill("death");
        hud destroy();
}