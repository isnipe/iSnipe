/*Alive People counting script by iNuke for iSnipe 3*/

#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

CheckTeam()
{

if (level.alivecounterstarted != 1)
{
level.alivecounterstarted = 1;
level.alliesalive = 0;
level.axisalive = 0;
}



self.ateam = self.pers["team"];

if (self.ateam == "allies")
    {
    level.alliesalive += 1;
    } else if (self.ateam == "axis") {
    level.axisalive += 1;
    }

self thread DoLabel();

self waittill("death");

if (self.ateam == "allies")
    {
    level.alliesalive -= 1;
    } else if (self.ateam == "axis") {
    level.axisalive -= 1;
    }

}

DoLabel()
{
self endon("death");
lbl = self createFontString("hudbig", 0.8);
lbl setPoint("TOPLEFT", "TOPLEFT", 44, 110);
self thread deleteondeath(lbl);
lbl.hideWhenInMenu = true;
for(;;)
{

if (self.ateam == "allies")
    {
    if (getDvar("g_gametype") != "dm"){

lbl setText("^2" + level.alliesalive+ " ^1" +level.axisalive);
    } else {
    //FREE FOR ALL

    lbl setText("^21" + " ^1" + (level.players.size -1));

    }
    } else if (self.ateam == "axis") {
        if (getDvar("g_gametype") != "dm"){
lbl setText("^2" + level.axisalive+ " ^1" + level.alliesalive);
} else {
lbl setText("^21" + " ^1" + (level.players.size - 1));
}
    }
wait 0.1;
}

}

deleteondeath(hud)
{
        self waittill("death");
        hud destroy();
}