package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author Norwigi
	 */
	public class Oneliner extends MovieClip
	{
		private var holder:MovieClip = new MovieClip();
		private var text:TextField = new TextField();
		private var format:TextFormat = new TextFormat("arial", 72, null, true );
		private var timer:Timer = new Timer(2000, 1);
		
		public function Oneliner() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			format.align = TextFormatAlign.CENTER;
			format.align = TextFormatAlign.CENTER;
			format.color = getColor(Main.randomRange(1, 3));
			text.defaultTextFormat = format;
			text.text = getText(Main.randomRange(1,30));
			text.width = stage.stageWidth;
			text.height = 100
			text.wordWrap = true;
			text.selectable = false;
			verticalAlignTextField(text);
			addChild(text);
			var outline:GlowFilter = new GlowFilter(0x000000, 1.0, 2.0, 2.0, 10);
			outline.quality=BitmapFilterQuality.MEDIUM;
			text.filters = [outline];
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, destroy);
			timer.start();
			holder.addChild(text);
			addChild(holder);
			
			text.x = -(stage.stageWidth/2);
			text.y = -(text.height);
			holder.x = stage.stageWidth/2;
			holder.y = stage.stageHeight/2;
		}
		
		private function destroy(e:TimerEvent):void 
		{
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, destroy);
			Main(parent).removeChild(this);
		}
		
		private function getColor(num:Number):uint 
		{
			switch(num) {
				case 1: return 0x00FFFF; break;
				case 2: return 0xFF00FF; break;
				case 3: return 0xFFFF00; break;
			}
			return null;
		}
		
		private function getText(num:Number):String 
		{
			switch(num) {
				case 1: return "Stay a while, and listen!"; break;
				case 2: return "But our Princess is in another castle!"; break;
				case 3: return "You have died of dysentery"; break;
				case 4: return "Wakka wakka wakka!"; break;
				case 5: return "The experiment is nearing its conclusion."; break;
				case 6: return "First blood!"; break;
				case 7: return "C-c-c-combo breaker!"; break;
				case 8: return "Killtacular!"; break;
				case 9: return "Boomshakalaka!"; break;
				case 10: return "Finish him!!"; break;
				case 11: return "Stay awhile... Stay FOREVER!"; break;
				case 12: return "La Li Lu Le Lo"; break;
				case 13: return "SNAAAAAAAAKE!!!"; break;
				case 14: return "Nuclear launch detected."; break;
				case 15: return "You spoony bard!"; break;
				case 16: return "Objection!"; break;
				case 17: return "I am error."; break;
				case 18: return "Hey! Listen!"; break;
				case 19: return "Frankly, I’m ashamed."; break;
				case 20: return "You are likely to be eaten by a grue."; break;
				case 21: return "Henshin a go-go, baby!"; break;
				case 22: return "Fus-ro-dah!"; break;
				case 23: return "Say, fuzzy pickles."; break;
				case 24: return "Welcome to Summoner’s Rift."; break;
				case 25: return "It’s super effective!"; break;
				case 26: return "Do a barrel roll!"; break;
				case 27: return "Rise and shine, Mr. Freeman."; break;
				case 28: return "Are you a boy? Or are you a girl?"; break;
				case 29: return "She was smilin’ till the end."; break;
				case 30: return "Prepare for unforseen consequences."; break;
			}
			return null;
		}
		
		private function verticalAlignTextField(tf: TextField): void {
			tf.y += Math.round((tf.height - tf.textHeight) / 2);
		}
		
	}

}