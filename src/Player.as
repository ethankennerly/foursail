package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Norwigi
	 */
	public class Player extends MovieClip
	{
		private var playerNumber:int = new int();
		private var playerSize:Point = new Point(40, 40);
		private var spawnDistanceFromEdge:int = new int(50);
		private var border:int;
		private var playerControls:Object;
		private var buttonStatus:Object = { Left:false, Right:false, Up:false, Down:false };
		private var speed:int = new int(10);
		
		private var playerColor:uint = new uint();
		
		private var tempScore:int = new int(0);
		private var collectToScore:int = new int(150);
		
		public var goalObject:MovieClip = new MovieClip();
		public var goalIndicator:MovieClip = new MovieClip();
		public var playerObject:MovieClip = new MovieClip();
		
		/**
		 * Define a new player.
		 * @param playerNumber
		 * Player (1-4)
		 */
		public function Player(playerNumber:int) 
		{
			this.playerNumber = playerNumber;
			addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			addChild(playerObject);
			this.x = 0;
			this.y = 0;
			playerObject.graphics.beginFill(0x00000);
			playerObject.graphics.drawRect( -(playerSize.x / 2) - 1, -(playerSize.y / 2) - 1, playerSize.x + 2, playerSize.y + 2);
			
			switch(playerNumber) {
				case 1: 
					playerColor = ChainJam.PLAYER1_COLOR;
					playerObject.graphics.beginFill(playerColor);
					playerControls = { Left:ChainJam.PLAYER1_LEFT, Right:ChainJam.PLAYER1_RIGHT, Up:ChainJam.PLAYER1_UP, Down:ChainJam.PLAYER1_DOWN, A1:ChainJam.PLAYER1_ACTION1, A2:ChainJam.PLAYER1_ACTION2 } ;
					playerObject.x = playerSize.x / 2 + spawnDistanceFromEdge;
					playerObject.y = playerSize.y / 2 + spawnDistanceFromEdge;
					goalObject.graphics.lineStyle(2, playerColor);
					goalObject.graphics.moveTo(Main.goalSize, 0);
					goalObject.graphics.lineTo(Main.goalSize, Main.goalSize);
					goalObject.graphics.lineTo(0, Main.goalSize);
					goalObject.x = Main.border;
					goalObject.y = Main.border;
				break;
				case 2: 
					playerColor = ChainJam.PLAYER2_COLOR;
					playerObject.graphics.beginFill(playerColor);
					playerControls = { Left:ChainJam.PLAYER2_LEFT, Right:ChainJam.PLAYER2_RIGHT, Up:ChainJam.PLAYER2_UP, Down:ChainJam.PLAYER2_DOWN, A1:ChainJam.PLAYER2_ACTION1, A2:ChainJam.PLAYER2_ACTION2 } ;
					playerObject.x = stage.stageWidth - (playerSize.x / 2) -spawnDistanceFromEdge;
					playerObject.y = playerSize.y / 2 +spawnDistanceFromEdge;
					goalObject.graphics.lineStyle(2, playerColor);
					goalObject.graphics.moveTo(Main.goalSize, 0);
					goalObject.graphics.lineTo(Main.goalSize, Main.goalSize);
					goalObject.graphics.lineTo(0, Main.goalSize);
					goalObject.x = stage.stageWidth - Main.border;
					goalObject.y = Main.border;
					goalObject.scaleX = -1;
				break;
				case 3: 
					playerColor = ChainJam.PLAYER3_COLOR;
					playerObject.graphics.beginFill(playerColor);
					playerControls =  { Left:ChainJam.PLAYER3_LEFT, Right:ChainJam.PLAYER3_RIGHT, Up:ChainJam.PLAYER3_UP, Down:ChainJam.PLAYER3_DOWN, A1:ChainJam.PLAYER3_ACTION1, A2:ChainJam.PLAYER3_ACTION2 } ;
					playerObject.x = stage.stageWidth - (playerSize.x / 2)-spawnDistanceFromEdge;
					playerObject.y = stage.stageHeight - (playerSize.y / 2) - spawnDistanceFromEdge;
					goalObject.graphics.lineStyle(2, playerColor);
					goalObject.graphics.moveTo(Main.goalSize, 0);
					goalObject.graphics.lineTo(Main.goalSize, Main.goalSize);
					goalObject.graphics.lineTo(0, Main.goalSize);
					goalObject.x = stage.stageWidth - Main.border;
					goalObject.y = stage.stageHeight - Main.border;
					goalObject.scaleX = goalObject.scaleY = -1;
				break;
				case 4: 
					playerColor = ChainJam.PLAYER4_COLOR;
					playerObject.graphics.beginFill(playerColor);
					playerControls =  { Left:ChainJam.PLAYER4_LEFT, Right:ChainJam.PLAYER4_RIGHT, Up:ChainJam.PLAYER4_UP, Down:ChainJam.PLAYER4_DOWN, A1:ChainJam.PLAYER4_ACTION1, A2:ChainJam.PLAYER4_ACTION2 } ;
					playerObject.x = playerSize.x / 2+spawnDistanceFromEdge;
					playerObject.y = stage.stageHeight - (playerSize.y / 2) - spawnDistanceFromEdge;
					goalObject.graphics.lineStyle(2, playerColor);
					goalObject.graphics.moveTo(Main.goalSize, 0);
					goalObject.graphics.lineTo(Main.goalSize, Main.goalSize);
					goalObject.graphics.lineTo(0, Main.goalSize);
					goalObject.x = Main.border;
					goalObject.y = stage.stageHeight - Main.border;
					goalObject.scaleY = -1;
				break;
			}
			
			goalIndicator.graphics.beginFill(playerColor);
			goalIndicator.graphics.drawRect( -(Main.goalSize / 2), -(Main.goalSize / 2), Main.goalSize, Main.goalSize);
			goalIndicator.x = goalIndicator.y = Main.goalSize / 2;
			goalIndicator.scaleX = goalIndicator.scaleY = tempScore / 100;
			
			playerObject.graphics.drawRect( -(playerSize.x / 2), -(playerSize.y / 2), playerSize.x, playerSize.y);
			
			addChild(goalObject);
			goalObject.addChild(goalIndicator);
			
			border = Main.border + (playerSize.x / 2);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased);
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function keyPressed(e:KeyboardEvent):void 
		{
			if (e.keyCode == playerControls.Left) {
				buttonStatus.Right = false;
				buttonStatus.Left = true;
			}else if (e.keyCode == playerControls.Right) {
				buttonStatus.Left = false;
				buttonStatus.Right = true;
			}else if (e.keyCode == playerControls.Up) {
				buttonStatus.Down = false;
				buttonStatus.Up = true;
			}else if (e.keyCode == playerControls.Down) {
				buttonStatus.Up = false;
				buttonStatus.Down = true;
			}else if (e.keyCode == playerControls.A1 || e.keyCode == playerControls.A2) {
				action();
			}
		}
		
		private function keyReleased(e:KeyboardEvent):void 
		{
			if(Main.playerStopOnRelease){
				if (e.keyCode == playerControls.Left) {
					buttonStatus.Left = false;
				}else if (e.keyCode == playerControls.Right) {
					buttonStatus.Right = false;
				}else if (e.keyCode == playerControls.Up) {
					buttonStatus.Up = false;
				}else if (e.keyCode == playerControls.Down) {
					buttonStatus.Down = false;
				}
			}
		}
		
		private function update(e:Event):void
		{
			var curSpeed:int
			if (Main.playerSpeedBoost) {
				curSpeed = speed + speed;
			}else {
				curSpeed = speed;
			}
			
			if (Main.inverseY) {
				if (buttonStatus.Up) { playerObject.y += curSpeed };
				if (buttonStatus.Down) { playerObject.y -= curSpeed };
			}else{
				if (buttonStatus.Up) { playerObject.y -= curSpeed };
				if (buttonStatus.Down) { playerObject.y += curSpeed };
			}
			
			if (Main.inverseX) {
				if (buttonStatus.Left) { playerObject.x += curSpeed };
				if (buttonStatus.Right) { playerObject.x -= curSpeed };
			}else{
				if (buttonStatus.Left) { playerObject.x -= curSpeed };
				if (buttonStatus.Right) { playerObject.x += curSpeed };
			}
			
			if (playerObject.x < border) { playerObject.x = border }
			if (playerObject.x > stage.stageWidth-border) { playerObject.x = stage.stageWidth-border}
			if (playerObject.y < border) { playerObject.y = border }
			if (playerObject.y > stage.stageHeight - border) { playerObject.y = stage.stageHeight - border }
		}
		
		public function capture():void {
			tempScore++;
			if (tempScore == collectToScore) { 
				tempScore = 0 
				Main.score(playerNumber);
			};
			goalIndicator.scaleX = goalIndicator.scaleY = tempScore / collectToScore;
						
		}
		
		private function action():void 
		{
			Main(parent).action();
		}
	}
}