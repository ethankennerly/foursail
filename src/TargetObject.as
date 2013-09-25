package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Norwigi
	 */
	public class TargetObject extends MovieClip
	{
		private var maxDist:Number = new Number(150);
		private var speed:Number = new Number(3);
		private var edgeDistance:int = new int(40);
		private var isBlack:Boolean = new Boolean(false);
		private var currentColor:String = new String("normal");
		
		public function TargetObject() 
		{
			speed = Main.randomRange(4000, 10000) / 1000;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			switch(Main.randomRange(1, 3)) {
				case 1: graphics.beginFill(0x0000FF); break;
				case 2: graphics.beginFill(0x00FF00); break;
				case 3: graphics.beginFill(0xFF0000); break;
			}
			
			graphics.drawCircle(0, 0, 10);
			
			this.x = Main.randomRange(Main.border+edgeDistance, stage.stageWidth - Main.border-edgeDistance);
			
			if (this.x < Main.border + Main.goalSize +edgeDistance|| this.x > stage.stageWidth - Main.border - Main.goalSize-edgeDistance) {
				this.y = Main.randomRange(Main.border + Main.goalSize+edgeDistance, stage.stageHeight-Main.border-Main.goalSize-edgeDistance);
			}else {
				this.y = Main.randomRange(Main.border+edgeDistance, stage.stageHeight - Main.border-edgeDistance);
			}
			addEventListener(Event.ENTER_FRAME, updatePoss);
		}
		
		private function updatePoss(e:Event):void 
		{
			if (Main.gameOver) {
				removeEventListener(Event.ENTER_FRAME, updatePoss);
			}
			var oldPoss:Point = new Point(this.x, this.y);
			
			var distance:Number = DistanceTwoPoints(this.x, Main(parent).player1.playerObject.x,this.y, Main(parent).player1.playerObject.y);
			var closest:int = 1;
			
			if (DistanceTwoPoints(this.x, Main(parent).player2.playerObject.x, this.y, Main(parent).player2.playerObject.y) < distance) {
				distance = DistanceTwoPoints(this.x, Main(parent).player2.playerObject.x, this.y, Main(parent).player2.playerObject.y);
				closest = 2;
			}if (DistanceTwoPoints(this.x, Main(parent).player3.playerObject.x, this.y, Main(parent).player3.playerObject.y) < distance) {
				distance = DistanceTwoPoints(this.x, Main(parent).player3.playerObject.x, this.y, Main(parent).player3.playerObject.y);
				closest = 3;
			}if (DistanceTwoPoints(this.x, Main(parent).player4.playerObject.x, this.y, Main(parent).player4.playerObject.y) < distance) {
				distance = DistanceTwoPoints(this.x, Main(parent).player4.playerObject.x, this.y, Main(parent).player4.playerObject.y);
				closest = 4;
			}
			
			if (Main.magnetic && speed < 0 ) {
				speed = speed * -1;
			}if (!Main.magnetic && speed > 0 ) {
				speed = speed * -1;
			}
			
			var dir:Number;
			if(distance<maxDist && distance > 5){
				if (closest == 1) {
					dir = Math.atan2(Main(parent).player1.playerObject.y - this.y, Main(parent).player1.playerObject.x - this.x) * 180 / Math.PI
					this.x += Math.cos(dir*Math.PI/180)*speed
					this.y += Math.sin(dir * Math.PI / 180) * speed
				}else if(closest == 2){
					dir = Math.atan2(Main(parent).player2.playerObject.y - this.y, Main(parent).player2.playerObject.x - this.x) * 180 / Math.PI
					this.x += Math.cos(dir*Math.PI/180)*speed
					this.y += Math.sin(dir * Math.PI / 180) * speed
				}else if (closest == 3){
					dir = Math.atan2(Main(parent).player3.playerObject.y - this.y, Main(parent).player3.playerObject.x - this.x) * 180 / Math.PI
					this.x += Math.cos(dir*Math.PI/180)*speed
					this.y += Math.sin(dir * Math.PI / 180) * speed
				}else if(closest == 4){
					dir = Math.atan2(Main(parent).player4.playerObject.y - this.y, Main(parent).player4.playerObject.x - this.x) * 180 / Math.PI
					this.x += Math.cos(dir*Math.PI/180)*speed
					this.y += Math.sin(dir * Math.PI / 180) * speed
				}
			}
			
			if (this.x < Main.border + Main.goalSize && this.y < Main.border + Main.goalSize) {
				Main(parent).capture(1);
				destroy();
			}else if (this.x > stage.stageWidth-(Main.border + Main.goalSize) && this.y < Main.border + Main.goalSize) {
				Main(parent).capture(2);
				destroy();
			}else if (this.x > stage.stageWidth-(Main.border + Main.goalSize) && this.y > stage.stageHeight-(Main.border + Main.goalSize)) {
				Main(parent).capture(3);
				destroy();
			}else if (this.x < Main.border + Main.goalSize && this.y > stage.stageHeight-(Main.border + Main.goalSize)) {
				Main(parent).capture(4);
				destroy();
			}
			else if (this.x < Main.border) { this.x = Main.border }
			else if (this.y < Main.border) { this.y = Main.border }
			else if (this.x > stage.stageWidth - Main.border) { this.x = stage.stageWidth - Main.border }
			else if (this.y > stage.stageHeight - Main.border) { this.y = stage.stageHeight - Main.border }
			
			if (isBlack) {
				if (this.x == oldPoss.x && this.y == oldPoss.y && currentColor != "black") {
					currentColor = "black";
					graphics.clear();
					graphics.beginFill(0x000000);
					graphics.drawCircle(0, 0, 10);
				}else if ( (this.x != oldPoss.x || this.y != oldPoss.y) && currentColor != "white") {
					currentColor = "white";
					graphics.clear();
					graphics.beginFill(0xFFFFFF);
					graphics.drawCircle(0, 0, 10);
				}
			}
			if (Main.selfMove && this.x == oldPoss.x && this.y == oldPoss.y) {
				this.x = Main.randomRange(this.x - 5, this.x + 5);
				this.y = Main.randomRange(this.y - 5, this.y + 5);
			}
			
			
		}
		
		private function destroy():void 
		{
			removeEventListener(Event.ENTER_FRAME, updatePoss);
			Main(parent).removeChild(this);
		}
		
		private function DistanceTwoPoints(x1:Number, x2:Number,  y1:Number, y2:Number):
			Number {
			var dx:Number = x1-x2;
			var dy:Number = y1-y2;
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		public function makeBlack():void {
			isBlack = true;
		}
		
		public function replace():void {
			this.x = Main.randomRange(Main.border+edgeDistance, stage.stageWidth - Main.border-edgeDistance);
			
			if (this.x < Main.border + Main.goalSize +edgeDistance|| this.x > stage.stageWidth - Main.border - Main.goalSize-edgeDistance) {
				this.y = Main.randomRange(Main.border + Main.goalSize+edgeDistance, stage.stageHeight-Main.border-Main.goalSize-edgeDistance);
			}else {
				this.y = Main.randomRange(Main.border+edgeDistance, stage.stageHeight - Main.border-edgeDistance);
			}
		}
	}

}