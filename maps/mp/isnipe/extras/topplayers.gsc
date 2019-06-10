//Top players tracking script by iNuke -- Still in development

#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

InitTopPlayers()
{

if (level.topplayersinitialized != 1)
{
level.topplayersinitialized = 1;

level.topplayers = [];
level.topplayers[1] = "";
level.topplayers[2] = "";
level.topplayers[3] = "";

level.playername = [];
level.playername[1] = "";
level.playername[2] = "";
level.playername[3] = "";
level.playername[4] = "";
level.playername[5] = "";
level.playername[6] = "";
level.playername[7] = "";
level.playername[8] = "";
level.playername[9] = "";
level.playername[10] = "";
level.playername[11] = "";
level.playername[12] = "";
level.playername[13] = "";
level.playername[14] = "";
level.playername[15] = "";
level.playername[16] = "";
level.playername[17] = "";
level.playername[18] = "";

level.playerscore = [];
level.playerscore[1] = 0;
level.playerscore[2] = 0;
level.playerscore[3] = 0;
level.playerscore[4] = 0;
level.playerscore[5] = 0;
level.playerscore[6] = 0;
level.playerscore[7] = 0;
level.playerscore[8] = 0;
level.playerscore[9] = 0;
level.playerscore[10] = 0;
level.playerscore[11] = 0;
level.playerscore[12] = 0;
level.playerscore[13] = 0;
level.playerscore[14] = 0;
level.playerscore[15] = 0;
level.playerscore[16] = 0;
level.playerscore[17] = 0;
level.playerscore[18] = 0;
}


self thread GetTopPlayerList();
}

PutSelfInList()
{
if (level.playername[1] == "") { level.playername[1] = self.name;level.playerscore[1] = 0;self.listnumber = 1;}
else if (level.playername[2] == "") { level.playername[2] = self.name;level.playerscore[2] = 0;self.listnumber = 2;}
else if (level.playername[3] == "") { level.playername[3] = self.name;level.playerscore[3] = 0;self.listnumber = 3;}
else if (level.playername[4] == "") { level.playername[4] = self.name;level.playerscore[4] = 0;self.listnumber = 4;}
else if (level.playername[5] == "") { level.playername[5] = self.name;level.playerscore[5] = 0;self.listnumber = 5;}
else if (level.playername[6] == "") { level.playername[6] = self.name;level.playerscore[6] = 0;self.listnumber = 6;}
else if (level.playername[7] == "") { level.playername[7] = self.name;level.playerscore[7] = 0;self.listnumber = 7;}
else if (level.playername[8] == "") { level.playername[8] = self.name;level.playerscore[8] = 0;self.listnumber = 8;}
else if (level.playername[9] == "") { level.playername[9] = self.name;level.playerscore[9] = 0;self.listnumber = 9;}
else if (level.playername[10] == "") { level.playername[10] = self.name;level.playerscore[10] = 0;self.listnumber = 10;}
else if (level.playername[11] == "") { level.playername[11] = self.name;level.playerscore[11] = 0;self.listnumber = 11;}
else if (level.playername[12] == "") { level.playername[12] = self.name;level.playerscore[12] = 0;self.listnumber = 12;}
else if (level.playername[13] == "") { level.playername[13] = self.name;level.playerscore[13] = 0;self.listnumber = 13;}
else if (level.playername[14] == "") { level.playername[14] = self.name;level.playerscore[14] = 0;self.listnumber = 14;}
else if (level.playername[15] == "") { level.playername[15] = self.name;level.playerscore[15] = 0;self.listnumber = 15;}
else if (level.playername[16] == "") { level.playername[16] = self.name;level.playerscore[16] = 0;self.listnumber = 16;}
else if (level.playername[17] == "") { level.playername[17] = self.name;level.playerscore[17] = 0;self.listnumber = 17;}
else if (level.playername[18] == "") { level.playername[18] = self.name;level.playerscore[18] = 0;self.listnumber = 18;}
}

GetTopPlayerList()
{
self PutSelfInList();
self thread KeepOwnScoreUpdated();
self thread GetThreeTopPlayers();
self thread DoHUD();
}

DoHUD()
{
self endon("death");
wait 5;

topplayerstitle = self createFontString("hud", 1);
topplayerstitle setPoint("CENTERRIGHT", "CENTERRIGHT", -5, 0);

topone = self createFontString("hud", 0.9);
topone setPoint("CENTERRIGHT", "CENTERRIGHT", -5, 12);

topplayerstitle.hideWhenInMenu = true;
topone.hideWhenInMenu = true;
topplayerstitle.alpha = 0.8;
topone.alpha = 0.8;

self thread deleteondeath(topplayerstitle);
self thread deleteondeath(topone);

for(;;)
{
if (level.topplayerone == 1337)
{
topplayerstitle setText("");
topone setText("");
} else {
topplayerstitle setText("^1TOP PLAYER");
topone setText("^3" + level.playername[level.topplayerone] + "^7 K/D: " + level.playerscore[level.topplayerone]);
}
wait 0.05;
}
}

deleteondeath(hud)
{
        self waittill("death");
        hud destroy();
}

GetThreeTopPlayers()
{
self endon("death");
for(;;)
{
level.topplayerone = GetPlayerOne();
topplayertwo = "";
topplayerthree = "";
wait 0.5;
}
}

GetPlayerOne()
{
if (level.playerscore[1] > level.playerscore[2] && level.playerscore[1] > level.playerscore[3]  && level.playerscore[1] > level.playerscore[4] && level.playerscore[1] > level.playerscore[5] && level.playerscore[1] > level.playerscore[6] && level.playerscore[1] > level.playerscore[7] && level.playerscore[1] > level.playerscore[8] && level.playerscore[1] > level.playerscore[9] && level.playerscore[1] > level.playerscore[10] && level.playerscore[1] > level.playerscore[11] && level.playerscore[1] > level.playerscore[12] && level.playerscore[1] > level.playerscore[13] && level.playerscore[1] > level.playerscore[14] && level.playerscore[1] > level.playerscore[15] && level.playerscore[1] > level.playerscore[16] && level.playerscore[1] > level.playerscore[17] && level.playerscore[1] > level.playerscore[18]) {
return 1;
} else if (level.playerscore[2] > level.playerscore[1] && level.playerscore[2] > level.playerscore[3]  && level.playerscore[2] > level.playerscore[4] && level.playerscore[2] > level.playerscore[5] && level.playerscore[2] > level.playerscore[6] && level.playerscore[2] > level.playerscore[7] && level.playerscore[2] > level.playerscore[8] && level.playerscore[2] > level.playerscore[9] && level.playerscore[2] > level.playerscore[10] && level.playerscore[2] > level.playerscore[11] && level.playerscore[2] > level.playerscore[12] && level.playerscore[2] > level.playerscore[13] && level.playerscore[2] > level.playerscore[14] && level.playerscore[2] > level.playerscore[15] && level.playerscore[2] > level.playerscore[16] && level.playerscore[2] > level.playerscore[17] && level.playerscore[2] > level.playerscore[18]){
return 2;
} else if (level.playerscore[3] > level.playerscore[1] && level.playerscore[3] > level.playerscore[2]  && level.playerscore[3] > level.playerscore[4] && level.playerscore[3] > level.playerscore[5] && level.playerscore[3] > level.playerscore[6] && level.playerscore[3] > level.playerscore[7] && level.playerscore[3] > level.playerscore[8] && level.playerscore[3] > level.playerscore[9] && level.playerscore[3] > level.playerscore[10] && level.playerscore[3] > level.playerscore[11] && level.playerscore[3] > level.playerscore[12] && level.playerscore[3] > level.playerscore[13] && level.playerscore[3] > level.playerscore[14] && level.playerscore[3] > level.playerscore[15] && level.playerscore[3] > level.playerscore[16] && level.playerscore[3] > level.playerscore[17] && level.playerscore[3] > level.playerscore[18]){
return 3;
} else if (level.playerscore[4] > level.playerscore[1] && level.playerscore[4] > level.playerscore[2]  && level.playerscore[4] > level.playerscore[3] && level.playerscore[4] > level.playerscore[5] && level.playerscore[4] > level.playerscore[6] && level.playerscore[4] > level.playerscore[7] && level.playerscore[4] > level.playerscore[8] && level.playerscore[4] > level.playerscore[9] && level.playerscore[4] > level.playerscore[10] && level.playerscore[4] > level.playerscore[11] && level.playerscore[4] > level.playerscore[12] && level.playerscore[4] > level.playerscore[13] && level.playerscore[4] > level.playerscore[14] && level.playerscore[4] > level.playerscore[15] && level.playerscore[4] > level.playerscore[16] && level.playerscore[4] > level.playerscore[17] && level.playerscore[4] > level.playerscore[18]){
return 4;
} else if (level.playerscore[5] > level.playerscore[1] && level.playerscore[5] > level.playerscore[2]  && level.playerscore[5] > level.playerscore[3] && level.playerscore[5] > level.playerscore[4] && level.playerscore[5] > level.playerscore[6] && level.playerscore[5] > level.playerscore[7] && level.playerscore[5] > level.playerscore[8] && level.playerscore[5] > level.playerscore[9] && level.playerscore[5] > level.playerscore[10] && level.playerscore[5] > level.playerscore[11] && level.playerscore[5] > level.playerscore[12] && level.playerscore[5] > level.playerscore[13] && level.playerscore[5] > level.playerscore[14] && level.playerscore[5] > level.playerscore[15] && level.playerscore[5] > level.playerscore[16] && level.playerscore[5] > level.playerscore[17] && level.playerscore[5] > level.playerscore[18]){
return 5;
} else if (level.playerscore[6] > level.playerscore[1] && level.playerscore[6] > level.playerscore[2]  && level.playerscore[6] > level.playerscore[3] && level.playerscore[6] > level.playerscore[4] && level.playerscore[6] > level.playerscore[5] && level.playerscore[6] > level.playerscore[7] && level.playerscore[6] > level.playerscore[8] && level.playerscore[6] > level.playerscore[9] && level.playerscore[6] > level.playerscore[10] && level.playerscore[6] > level.playerscore[11] && level.playerscore[6] > level.playerscore[12] && level.playerscore[6] > level.playerscore[13] && level.playerscore[6] > level.playerscore[14] && level.playerscore[6] > level.playerscore[15] && level.playerscore[6] > level.playerscore[16] && level.playerscore[6] > level.playerscore[17] && level.playerscore[6] > level.playerscore[18])
{
return 6;
} else if (level.playerscore[7] > level.playerscore[1] && level.playerscore[7] > level.playerscore[2]  && level.playerscore[7] > level.playerscore[3] && level.playerscore[7] > level.playerscore[4] && level.playerscore[7] > level.playerscore[5] && level.playerscore[7] > level.playerscore[6] && level.playerscore[7] > level.playerscore[8] && level.playerscore[7] > level.playerscore[9] && level.playerscore[7] > level.playerscore[10] && level.playerscore[7] > level.playerscore[11] && level.playerscore[7] > level.playerscore[12] && level.playerscore[7] > level.playerscore[13] && level.playerscore[7] > level.playerscore[14] && level.playerscore[7] > level.playerscore[15] && level.playerscore[7] > level.playerscore[16] && level.playerscore[7] > level.playerscore[17] && level.playerscore[7] > level.playerscore[18])
{
return 7;
} else if (level.playerscore[8] > level.playerscore[1] && level.playerscore[8] > level.playerscore[2]  && level.playerscore[8] > level.playerscore[3] && level.playerscore[8] > level.playerscore[4] && level.playerscore[8] > level.playerscore[5] && level.playerscore[8] > level.playerscore[6] && level.playerscore[8] > level.playerscore[7] && level.playerscore[8] > level.playerscore[9] && level.playerscore[8] > level.playerscore[10] && level.playerscore[8] > level.playerscore[11] && level.playerscore[8] > level.playerscore[12] && level.playerscore[8] > level.playerscore[13] && level.playerscore[8] > level.playerscore[14] && level.playerscore[8] > level.playerscore[15] && level.playerscore[8] > level.playerscore[16] && level.playerscore[8] > level.playerscore[17] && level.playerscore[8] > level.playerscore[18])
{
return 8;
} else if (level.playerscore[9] > level.playerscore[1] && level.playerscore[9] > level.playerscore[2]  && level.playerscore[9] > level.playerscore[3] && level.playerscore[9] > level.playerscore[4] && level.playerscore[9] > level.playerscore[5] && level.playerscore[9] > level.playerscore[6] && level.playerscore[9] > level.playerscore[7] && level.playerscore[9] > level.playerscore[8] && level.playerscore[9] > level.playerscore[10] && level.playerscore[9] > level.playerscore[11] && level.playerscore[9] > level.playerscore[12] && level.playerscore[9] > level.playerscore[13] && level.playerscore[9] > level.playerscore[14] && level.playerscore[9] > level.playerscore[15] && level.playerscore[9] > level.playerscore[16] && level.playerscore[9] > level.playerscore[17] && level.playerscore[9] > level.playerscore[18])
{
return 9;
} else if (level.playerscore[10] > level.playerscore[1] && level.playerscore[10] > level.playerscore[2]  && level.playerscore[10] > level.playerscore[3] && level.playerscore[10] > level.playerscore[4] && level.playerscore[10] > level.playerscore[5] && level.playerscore[10] > level.playerscore[6] && level.playerscore[10] > level.playerscore[7] && level.playerscore[10] > level.playerscore[8] && level.playerscore[10] > level.playerscore[9] && level.playerscore[10] > level.playerscore[11] && level.playerscore[10] > level.playerscore[12] && level.playerscore[10] > level.playerscore[13] && level.playerscore[10] > level.playerscore[14] && level.playerscore[10] > level.playerscore[15] && level.playerscore[10] > level.playerscore[16] && level.playerscore[10] > level.playerscore[17] && level.playerscore[10] > level.playerscore[18])
{
return 10;
} else if (level.playerscore[11] > level.playerscore[1] && level.playerscore[11] > level.playerscore[2]  && level.playerscore[11] > level.playerscore[3] && level.playerscore[11] > level.playerscore[4] && level.playerscore[11] > level.playerscore[5] && level.playerscore[11] > level.playerscore[6] && level.playerscore[11] > level.playerscore[7] && level.playerscore[11] > level.playerscore[8] && level.playerscore[11] > level.playerscore[9] && level.playerscore[11] > level.playerscore[10] && level.playerscore[11] > level.playerscore[12] && level.playerscore[11] > level.playerscore[13] && level.playerscore[11] > level.playerscore[14] && level.playerscore[11] > level.playerscore[15] && level.playerscore[11] > level.playerscore[16] && level.playerscore[11] > level.playerscore[17] && level.playerscore[11] > level.playerscore[18])
{
return 11;
} else if (level.playerscore[12] > level.playerscore[1] && level.playerscore[12] > level.playerscore[2]  && level.playerscore[12] > level.playerscore[3] && level.playerscore[12] > level.playerscore[4] && level.playerscore[12] > level.playerscore[5] && level.playerscore[12] > level.playerscore[6] && level.playerscore[12] > level.playerscore[7] && level.playerscore[12] > level.playerscore[8] && level.playerscore[12] > level.playerscore[9] && level.playerscore[12] > level.playerscore[10] && level.playerscore[12] > level.playerscore[11] && level.playerscore[12] > level.playerscore[13] && level.playerscore[12] > level.playerscore[14] && level.playerscore[12] > level.playerscore[15] && level.playerscore[12] > level.playerscore[16] && level.playerscore[12] > level.playerscore[17] && level.playerscore[12] > level.playerscore[18])
{
return 12;
} else if (level.playerscore[13] > level.playerscore[1] && level.playerscore[13] > level.playerscore[2]  && level.playerscore[13] > level.playerscore[3] && level.playerscore[13] > level.playerscore[4] && level.playerscore[13] > level.playerscore[5] && level.playerscore[13] > level.playerscore[6] && level.playerscore[13] > level.playerscore[7] && level.playerscore[13] > level.playerscore[8] && level.playerscore[13] > level.playerscore[9] && level.playerscore[13] > level.playerscore[10] && level.playerscore[13] > level.playerscore[11] && level.playerscore[13] > level.playerscore[12] && level.playerscore[13] > level.playerscore[14] && level.playerscore[13] > level.playerscore[15] && level.playerscore[13] > level.playerscore[16] && level.playerscore[13] > level.playerscore[17] && level.playerscore[13] > level.playerscore[18])
{
return 13;
} else if (level.playerscore[14] > level.playerscore[1] && level.playerscore[14] > level.playerscore[2]  && level.playerscore[14] > level.playerscore[3] && level.playerscore[14] > level.playerscore[4] && level.playerscore[14] > level.playerscore[5] && level.playerscore[14] > level.playerscore[6] && level.playerscore[14] > level.playerscore[7] && level.playerscore[14] > level.playerscore[8] && level.playerscore[14] > level.playerscore[9] && level.playerscore[14] > level.playerscore[10] && level.playerscore[14] > level.playerscore[11] && level.playerscore[14] > level.playerscore[12] && level.playerscore[14] > level.playerscore[13] && level.playerscore[14] > level.playerscore[15] && level.playerscore[14] > level.playerscore[16] && level.playerscore[14] > level.playerscore[17] && level.playerscore[14] > level.playerscore[18])
{
return 14;
} else if (level.playerscore[15] > level.playerscore[1] && level.playerscore[15] > level.playerscore[2]  && level.playerscore[15] > level.playerscore[3] && level.playerscore[15] > level.playerscore[4] && level.playerscore[15] > level.playerscore[5] && level.playerscore[15] > level.playerscore[6] && level.playerscore[15] > level.playerscore[7] && level.playerscore[15] > level.playerscore[8] && level.playerscore[15] > level.playerscore[9] && level.playerscore[15] > level.playerscore[10] && level.playerscore[15] > level.playerscore[11] && level.playerscore[15] > level.playerscore[12] && level.playerscore[15] > level.playerscore[13] && level.playerscore[15] > level.playerscore[14] && level.playerscore[15] > level.playerscore[16] && level.playerscore[15] > level.playerscore[17] && level.playerscore[15] > level.playerscore[18])
{
return 15;
} else if (level.playerscore[16] > level.playerscore[1] && level.playerscore[16] > level.playerscore[2]  && level.playerscore[16] > level.playerscore[3] && level.playerscore[16] > level.playerscore[4] && level.playerscore[16] > level.playerscore[5] && level.playerscore[16] > level.playerscore[6] && level.playerscore[16] > level.playerscore[7] && level.playerscore[16] > level.playerscore[8] && level.playerscore[16] > level.playerscore[9] && level.playerscore[16] > level.playerscore[10] && level.playerscore[16] > level.playerscore[11] && level.playerscore[16] > level.playerscore[12] && level.playerscore[16] > level.playerscore[13] && level.playerscore[16] > level.playerscore[14] && level.playerscore[16] > level.playerscore[15] && level.playerscore[16] > level.playerscore[17] && level.playerscore[16] > level.playerscore[18])
{
return 16;
}else if (level.playerscore[17] > level.playerscore[1] && level.playerscore[17] > level.playerscore[2]  && level.playerscore[17] > level.playerscore[3] && level.playerscore[17] > level.playerscore[4] && level.playerscore[17] > level.playerscore[5] && level.playerscore[17] > level.playerscore[6] && level.playerscore[17] > level.playerscore[7] && level.playerscore[17] > level.playerscore[8] && level.playerscore[17] > level.playerscore[9] && level.playerscore[17] > level.playerscore[10] && level.playerscore[17] > level.playerscore[11] && level.playerscore[17] > level.playerscore[12] && level.playerscore[17] > level.playerscore[13] && level.playerscore[17] > level.playerscore[14] && level.playerscore[17] > level.playerscore[15] && level.playerscore[17] > level.playerscore[16] && level.playerscore[17] > level.playerscore[18])
{
return 17;
} else if (level.playerscore[18] > level.playerscore[1] && level.playerscore[18] > level.playerscore[2]  && level.playerscore[18] > level.playerscore[3] && level.playerscore[18] > level.playerscore[4] && level.playerscore[18] > level.playerscore[5] && level.playerscore[18] > level.playerscore[6] && level.playerscore[18] > level.playerscore[7] && level.playerscore[18] > level.playerscore[8] && level.playerscore[18] > level.playerscore[9] && level.playerscore[18] > level.playerscore[10] && level.playerscore[18] > level.playerscore[11] && level.playerscore[18] > level.playerscore[12] && level.playerscore[18] > level.playerscore[13] && level.playerscore[18] > level.playerscore[14] && level.playerscore[18] > level.playerscore[15] && level.playerscore[18] > level.playerscore[16] && level.playerscore[18] > level.playerscore[17])
{
return 18;
} else {
return 1337;
}
}


KeepOwnScoreUpdated()
{
for(;;)
{
curkills = (self getPlayerStat( "kills" ));
curdeaths = (self getPlayerStat( "deaths" ));
if (curdeaths == 0)
{
kdcalc = (curkills);
} else {
kdcalc = (curkills) / (curdeaths);
}

level.playerscore[self.listnumber] = kdcalc;

wait 0.1;
}
}
