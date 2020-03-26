// TODO: How to add settings into the mix.
init() {
    self maps\mp\isnipe\extras\anticamp::init();
    self maps\mp\isnipe\extras\topplayer::init();
}

onPlayerConnect() {
    self maps\mp\isnipe\extras\anticamp::onPlayerConnect();
    self maps\mp\isnipe\extras\topplayer::onPlayerConnect();
}

onPlayerSpawned() {
    self maps\mp\isnipe\extras\anticamp::onPlayerSpawned();
    self maps\mp\isnipe\extras\topplayer::onPlayerSpawned();
}