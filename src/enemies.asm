.DEFINE COLOR_GRAY 		$00
.DEFINE COLOR_RED 		$01
.DEFINE COLOR_ORANGE	$02
.DEFINE COLOR_GREEN		$03
.DEFINE COLOR_AQUA		$04
.DEFINE COLOR_BLUE		$05
.DEFINE COLOR_PURPLE	$06

.BANK $0F SLOT 1
.SECTION "EnemyColors" FREE
EnemyColors:
	;00 Fungus			01 Mushroom			02 Champgno			03 Shiitake			04 Toadstol
	.db COLOR_GREEN,	COLOR_ORANGE,		COLOR_AQUA,			COLOR_GRAY,			COLOR_PURPLE
	;05 Flower			06 P-Flower			07 F-Flower			08 SunPlant			09 DarkRose
	.db COLOR_GREEN,	COLOR_PURPLE,		COLOR_RED,			COLOR_ORANGE,		COLOR_BLUE
	;0A MapleMan		0B LiveOrk			0C EvilPine			0D MadCeder			0E Treant
	.db COLOR_ORANGE,	COLOR_GREEN,		COLOR_RED,			COLOR_BLUE,			COLOR_PURPLE
	;0F Pebble			10 Cobble			11 Boulder			12 Rock				13 Earth
	.db COLOR_ORANGE,	COLOR_PURPLE,		COLOR_RED,			COLOR_GRAY,			COLOR_AQUA
	;14 Woodman			15 Clayman			16 Stoneman			17 Ironman			18 Mazin
	.db COLOR_ORANGE,	COLOR_PURPLE,		COLOR_GRAY,			COLOR_RED,			COLOR_BLUE
	;19 Hofud			1A Gae Bolg			1B Answerer			1C Moaner			1D Kusanagi
	.db COLOR_ORANGE,	COLOR_PURPLE,		COLOR_GRAY,			COLOR_RED,			COLOR_BLUE
	;1E Slime			1F Jelly			20 Tororo			21 Pudding			22 SlimeGod
	.db COLOR_GREEN,	COLOR_ORANGE,		COLOR_AQUA,			COLOR_GRAY,			COLOR_PURPLE
	;23 Worm			24 P-Worm			25 LavaWorm			26 SandWorm			27 GigaWorm
	.db COLOR_GREEN,	COLOR_PURPLE,		COLOR_RED,			COLOR_ORANGE,		COLOR_GRAY
	;28 Big Eye			29 Gazer			2A Watcher			2B Evil Eye			2C Beholder
	.db COLOR_PURPLE,	COLOR_AQUA,			COLOR_BLUE,			COLOR_RED,			COLOR_ORANGE
	;2D Spider			2E P-Spider			2F Tarantla			30 F-Spider			31 Arachne
	.db COLOR_GREEN,	COLOR_PURPLE,		COLOR_ORANGE,		COLOR_GRAY,			COLOR_BLUE
	;32 Beetle			33 Chafer			34 Ant Lion			35 C-Fisher			36 Scarab
	.db COLOR_PURPLE,	COLOR_AQUA,			COLOR_RED,			COLOR_BLUE,			COLOR_ORANGE
	;37 Moth			38 Swallow			39 FireMoth			3A Gloom			3B Madame
	.db COLOR_GRAY,		COLOR_AQUA,			COLOR_RED,			COLOR_PURPLE,		COLOR_ORANGE
	;3C Octopus			3D Amoeba			3E Ammonite			3F Squid			40 Kraken
	.db COLOR_BLUE,		COLOR_GRAY,			COLOR_AQUA,			COLOR_ORANGE,		COLOR_PURPLE
	;41 Barracud		42 Piranha			43 SHARK			44 GunFish			45 Leviathn
	.db COLOR_GREEN,	COLOR_RED,			COLOR_AQUA,			COLOR_GRAY,			COLOR_BLUE
	;46 Crab			47 Hermit			48 Ice Crab			49 KingCrab			4A Dagon
	.db COLOR_ORANGE,	COLOR_GRAY,			COLOR_AQUA,			COLOR_PURPLE,		COLOR_RED
	;4B Toad			4C P-Toad			4D HugeToad			4E GianToad			4F KingToad
	.db COLOR_GREEN,	COLOR_PURPLE,		COLOR_GRAY,			COLOR_ORANGE,		COLOR_RED
	;50 Snake			51 Serpent			52 Anaconda			53 Hydra			54 Jorgandr
	.db COLOR_GREEN,	COLOR_ORANGE,		COLOR_AQUA,			COLOR_GRAY,			COLOR_PURPLE
	;55 Tortoise		56 Turtle			57 Adamant			58 D-Turtle			59 Gen-Bu
	.db COLOR_ORANGE,	COLOR_GREEN,		COLOR_BLUE,			COLOR_PURPLE,		COLOR_GRAY
	;5A Lizard			5B Cameleon			5C Komodo			5D Salamand			5E Basalisk
	.db COLOR_GREEN,	COLOR_ORANGE,		COLOR_AQUA,			COLOR_RED,			COLOR_GRAY
	;5F Rhino			60 Triceras			61 Dinosaur			62 T Rex			63 Behemoth
	.db COLOR_GRAY,		COLOR_ORANGE,		COLOR_GREEN,		COLOR_RED,			COLOR_PURPLE
	;64 Baby-D			65 Young-D			66 Dragon			67 Great-D			68 Sei-Ryu
	.db COLOR_ORANGE,	COLOR_GREEN,		COLOR_PURPLE,		COLOR_GRAY,			COLOR_RED
	;69 BabyWyrm		6A Wyrm Kid			6B Wyvern			6C Wyrm				6D FengLung
	.db COLOR_ORANGE,	COLOR_AQUA,			COLOR_RED,			COLOR_GREEN,		COLOR_PURPLE
	;6E Eagle			6F Thunder			70 Cocatris			71 Roc				72 Su-Zaku
	.db COLOR_BLUE,		COLOR_ORANGE,		COLOR_GRAY,			COLOR_AQUA,			COLOR_PURPLE
	;73 Raven			74 Harpy			75 Ten-Gu			76 Garuda			77 Nike
	.db COLOR_PURPLE,	COLOR_ORANGE,		COLOR_GRAY,			COLOR_RED,			COLOR_BLUE
	;78 Jaguar			79 SabreCat			7A SnowCat			7B BlackCat			7C Byak-Ko
	.db COLOR_ORANGE,	COLOR_RED,			COLOR_AQUA,			COLOR_PURPLE,		COLOR_BLUE
	;7D Silver			7E Kelpie			7F Nitemare			80 Sleipnir			81 Unicorn
	.db COLOR_GRAY,		COLOR_GREEN,		COLOR_PURPLE,		COLOR_AQUA,			COLOR_RED
	;82 Griffon			83 Mantcore			84 Chimera			85 Sphinx			86 Kirin
	.db COLOR_AQUA,		COLOR_GREEN,		COLOR_RED,			COLOR_ORANGE,		COLOR_PURPLE
	;87 Fly				88 Hornet			89 Mosquito			8A Cicada			8B Mantis
	.db COLOR_GRAY,		COLOR_ORANGE,		COLOR_RED,			COLOR_PURPLE,		COLOR_ORANGE
	;8C WereRat			8D WereWolf			8E CatWoman			8F Rakshasa			90 Anubis
	.db COLOR_GRAY,		COLOR_ORANGE,		COLOR_AQUA,			COLOR_RED,			COLOR_PURPLE
	;91 Medusa			92 Lamia			93 Naga				94 Scylla			95 Lilith
	.db COLOR_GRAY,		COLOR_GREEN,		COLOR_ORANGE,		COLOR_BLUE,			COLOR_RED
	;96 Goblin			97 Oni				98 Ogre				99 Giant			9A Susano-O
	.db COLOR_GREEN,	COLOR_RED,			COLOR_ORANGE,		COLOR_GRAY,			COLOR_PURPLE
	;9B Fiend			9C Mephisto			9D Demon			9E DemoLord			9F Athtalot
	.db COLOR_GREEN,	COLOR_PURPLE,		COLOR_GRAY,			COLOR_ORANGE,		COLOR_RED
	;A0 Sprite			A1 Fairy			A2 Nymph			A3 Sylph			A4 Titania
	.db COLOR_ORANGE,	COLOR_BLUE,			COLOR_AQUA,			COLOR_PURPLE,		COLOR_GRAY
	;A5 Skelton			A6 Red Bone			A7 WARRIOR			A8 BoneKing			A9 Lich
	.db COLOR_GRAY,		COLOR_RED,			COLOR_ORANGE,		COLOR_PURPLE,		COLOR_BLUE
	;AA Zombie			AB Ghoul			AC Ghast			AD Wight			AE Revenant
	.db COLOR_GRAY,		COLOR_RED,			COLOR_ORANGE,		COLOR_PURPLE,		COLOR_BLUE
	;AF O-Bake			B0 Phantom			B1 Wraith			B2 Spector			B3 Ghost
	.db COLOR_GRAY,		COLOR_RED,			COLOR_ORANGE,		COLOR_PURPLE,		COLOR_BLUE
	;B4 Asigaru,		B5 Samurai			B6 Ninja			B7 Musashi			B8 Hatamoto
	.db COLOR_ORANGE,	COLOR_PURPLE,		COLOR_BLUE,			COLOR_GRAY,			COLOR_GREEN
	;B9 Gang			BA Wh. Belt			BB Killer			BC Bl. Belt			BD TianLung
	.db COLOR_ORANGE,	COLOR_GRAY,			COLOR_RED,			COLOR_PURPLE,		COLOR_BLUE
	;BE Trooper			BF Guard			C0 Knight			C1 Paladin			C2 Fenrir
	.db COLOR_AQUA,		COLOR_ORANGE,		COLOR_PURPLE,		COLOR_GRAY,			COLOR_GREEN
	;C3 Terorist		C4 Mercenar			C5 Commando			C6 SS	 			C7 EchigoYa
	.db COLOR_PURPLE,	COLOR_ORANGE,		COLOR_GREEN,		COLOR_GRAY,			COLOR_RED
	;C8 Conjurer		C9 Magician			CA Sorcerer			CB Wizard			CC INVALID
	.db COLOR_GREEN,	COLOR_GRAY,			COLOR_BLUE,			COLOR_PURPLE,		$00
	;CD ROBO-28			CE ROBO-Z			CF Ridean			D0 G-7				D1 Dunatis
	.db COLOR_GREEN,	COLOR_PURPLE,		COLOR_ORANGE,		COLOR_GRAY,			COLOR_BLUE
	;D2 MechBug			D3 Hawk				D4 Falcon			D5 Intercpt			D6 INVALID
	.db COLOR_PURPLE,	COLOR_ORANGE,		COLOR_RED,			COLOR_BLUE,			$00
	;D7 Plasma			D8 Phagocyt			D9 Corpuscl			DA Cancer			DB INVALID
	.db COLOR_GRAY,		COLOR_AQUA,			COLOR_RED,			COLOR_PURPLE,		$00
	;DC Grippe			DD Virus			DE Pathogen			DF Plague			E0 INVALID
	.db COLOR_GRAY,		COLOR_AQUA,			COLOR_RED,			COLOR_PURPLE,		$00
	;E1 Teacher			E2 Cleric			E3 Unknown			E4 Unknown			E5 Girl
	.db COLOR_GREEN,	COLOR_GRAY,			$00,				$00,				COLOR_BLUE
	;E6 Guardian		E7 Girl				E8 Detectiv			E9 Samurai			EA Guardian
	.db COLOR_ORANGE,	COLOR_GRAY,			COLOR_AQUA,			COLOR_PURPLE,		COLOR_RED
	;EB Ancient			EC Haniwa			ED Dolphin			EE OdinCrow			EF WarMach
	.db COLOR_GREEN,	COLOR_PURPLE,		COLOR_GRAY,			COLOR_ORANGE,		COLOR_RED
	;F0 Human M			F1 Human F			F2 Mutant M			F3 Mutant F			F4 Robot
	.db COLOR_RED,		COLOR_BLUE,			COLOR_GREEN,		COLOR_ORANGE,		COLOR_BLUE
	;F5 Slime			F6 Baby-D			F7 Imp				F8 Ashura			F9 Venus
	.db COLOR_GREEN,	COLOR_GREEN,		COLOR_PURPLE,		COLOR_ORANGE,		COLOR_AQUA
	;FA Sho-Gun			FB Magnate			FC Odin				FD Minion			FE Apollo
	.db COLOR_GRAY,		COLOR_AQUA,			COLOR_ORANGE,		COLOR_BLUE,			COLOR_PURPLE
	;FF Arsenal
	.db COLOR_GRAY
.ENDS