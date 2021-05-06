package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class CutsceneDialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var nametag:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		trace("cum");

		trace(dialogueList[0]);
		super();

		box = new FlxSprite(0, 0);
		var hasDialog=true;
		box.loadGraphic(Paths.image('cutscenes/transDialogueBox'));

		box.updateHitbox();
		this.dialogueList = dialogueList;

		nametag = new FlxSprite(Std.int(FlxG.width/2), 40);
		nametag.loadGraphic(Paths.image('cutscenes/boyfriendname'));

		nametag.updateHitbox();
		nametag.scrollFactor.set();
		add(box);
		add(nametag);

		box.screenCenter(XY);
		nametag.screenCenter(XY);

		if (!talkingRight)
		{
			//box.flipX = true;
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.setFormat(Paths.font("vcr.ttf"), 32);
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.setFormat(Paths.font("vcr.ttf"), 32);
		swagDialogue.color = 0xFFFFFFFF;
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);

		startDialogue();
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = true;
	var dialogueStarted:Bool = true;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI

		dropText.text = swagDialogue.text;
		dialogueOpened=true;

		if (FlxG.keys.justPressed.ANY  && dialogueStarted == true)
		{
			remove(dialogue);

			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						nametag.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}

		super.update(elapsed);
	}

	var isEnding:Bool = false;

	var curLeft = '';
	var curRight = '';
	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		trace(dialogueList[0]);
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		switch(curCharacter){
			case 'flexy':
				nametag.loadGraphic(Paths.image('cutscenes/flexyname'));
				nametag.updateHitbox();
				nametag.scrollFactor.set();
				nametag.screenCenter(XY);
				dropText.color = 0xFFDEDEDE;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('dialogue/flexy'), 0.6)];
			case 'bf':
				nametag.loadGraphic(Paths.image('cutscenes/boyfriendname'));
				nametag.updateHitbox();
				nametag.scrollFactor.set();
				nametag.screenCenter(XY);
				dropText.color = 0xFF5A84FF;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('dialogue/bf'), 0.6)];
			case 'gf':
				nametag.loadGraphic(Paths.image('cutscenes/girlfriendname'));
				nametag.updateHitbox();
				nametag.scrollFactor.set();
				nametag.screenCenter(XY);
				dropText.color = 0xFFCA80AB;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('dialogue/gf'), 0.6)];
			case 'merchant':
				nametag.loadGraphic(Paths.image('cutscenes/merchantname'));
				nametag.updateHitbox();
				nametag.scrollFactor.set();
				nametag.screenCenter(XY);
				dropText.color = 0xFF8380CA;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('dialogue/merchant'), 0.6)];
			default:
				nametag.loadGraphic(Paths.image('cutscenes/unknownname'));
				nametag.updateHitbox();
				nametag.scrollFactor.set();
				nametag.screenCenter(XY);
				dropText.color = 0xFF5F6B62;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1].toLowerCase();
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
