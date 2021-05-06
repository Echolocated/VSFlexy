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
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class Cutscene extends FlxSpriteGroup {
  var data:Array<String> = [];
  var dialogueSections:Array<Array<String>>=[];
  public var finishThing:Void->Void;
  var dialogueBox:CutsceneDialogueBox;
  var cutsceneImage:FlxSprite;
  var cutsceneSec:Int = 0;
  var fader:FlxSprite;
  var canSkip:Bool=false;
  var shitPattern = new EReg("\\[.+\\]","i");
  public function new(?data:Array<String>){
    super();

    this.data=data;
    parseDialogue();
    cutsceneImage = new FlxSprite();
    updateGraphic();

    fader = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 3), Std.int(FlxG.height * 3), 0xFF000000);
    fader.scrollFactor.set();
    fader.alpha = 1;
    fader.setGraphicSize(Std.int(fader.width*(1+(1-FlxG.camera.zoom))));
    add(fader);

    FlxTween.tween(fader, {alpha: 0}, .5, {
      ease: FlxEase.quadInOut,
      onComplete: function(twn:FlxTween)
      {
        doShit();
      }
    });

  }

  function updateGraphic(){
    cutsceneImage.loadGraphic(Paths.image("cutscenes/BGS/c" + Std.string(cutsceneSec+1) ) );
    cutsceneImage.updateHitbox();

    cutsceneImage.setGraphicSize(1280,720);
    cutsceneImage.updateHitbox();
    cutsceneImage.screenCenter();
    add(cutsceneImage);
  }

  function doShit() {
    if(dialogueSections[cutsceneSec].length>0){
      canSkip=false;
      dialogueBox = new CutsceneDialogueBox(false, dialogueSections[cutsceneSec]);
      dialogueBox.finishThing = function(){
        cutsceneSec++;
        if(cutsceneSec==dialogueSections.length){
          FlxTween.tween(fader, {alpha: 1}, .5, {
            ease: FlxEase.quadInOut,
            onComplete: function(twn:FlxTween)
            {
              remove(cutsceneImage);
              FlxTween.tween(fader, {alpha: 0}, .5, {
                ease: FlxEase.quadInOut,
                onComplete: function(twn:FlxTween)
                {
                  remove(fader);
                  finishThing();
                }
              });
            }
          });
        }else{
          canSkip=true;
        }
      }
      add(dialogueBox);
    }else{
      cutsceneSec++;
      if(cutsceneSec==dialogueSections.length){
        FlxTween.tween(fader, {alpha: 0}, .5, {
          ease: FlxEase.quadInOut,
          onComplete: function(twn:FlxTween)
          {
            remove(cutsceneImage);
            FlxTween.tween(fader, {alpha: 1}, .5, {
              ease: FlxEase.quadInOut,
              onComplete: function(twn:FlxTween)
              {
                remove(fader);
                finishThing();
              }
            });
          }
        });
      }else{
        canSkip=true;
      }
    }
  }

  override function update(elapsed:Float){
    super.update(elapsed);
    if(canSkip && FlxG.keys.justPressed.ANY){
      canSkip=false;
      FlxTween.tween(fader, {alpha: 1}, .5, {
        ease: FlxEase.quadInOut,
        onComplete: function(twn:FlxTween)
        {
          FlxTween.tween(fader, {alpha: 0}, .5, {ease: FlxEase.quadInOut});
          updateGraphic();
          doShit();
        }
      });

    }
  }


  function parseDialogue(){
    var currentSection = -1;
    for (i in data){
      if(shitPattern.match(i) ){
        currentSection++;
        dialogueSections[currentSection]=[];
      }else{
        dialogueSections[currentSection].push(i);
      }
    }
  }
}
