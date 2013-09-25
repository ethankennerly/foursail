package  
{
	import flash.ui.Keyboard;
	import flash.external.ExternalInterface;
	/**
	 * ...
	 * @author Norwigi
	 */
	public class ChainJam 
	{
		public static const PLAYER1_LEFT:int = new int(Keyboard.LEFT);
		public static const PLAYER1_RIGHT:int = new int(Keyboard.RIGHT);
		public static const PLAYER1_UP:int = new int(Keyboard.UP);
		public static const PLAYER1_DOWN:int = new int(Keyboard.DOWN);
		public static const PLAYER1_ACTION1:int = new int(Keyboard.Z);
		public static const PLAYER1_ACTION2:int = new int(Keyboard.X);
		
		public static const PLAYER2_LEFT:int = new int(Keyboard.J);
		public static const PLAYER2_RIGHT:int = new int(Keyboard.L);
		public static const PLAYER2_UP:int = new int(Keyboard.I);
		public static const PLAYER2_DOWN:int = new int(Keyboard.K);
		public static const PLAYER2_ACTION1:int = new int(Keyboard.N);
		public static const PLAYER2_ACTION2:int = new int(Keyboard.M);
		
		public static const PLAYER3_LEFT:int = new int(Keyboard.A);
		public static const PLAYER3_RIGHT:int = new int(Keyboard.D);
		public static const PLAYER3_UP:int = new int(Keyboard.W);
		public static const PLAYER3_DOWN:int = new int(Keyboard.S);
		public static const PLAYER3_ACTION1:int = new int(Keyboard.Q);
		public static const PLAYER3_ACTION2:int = new int(Keyboard.E);
		
		public static const PLAYER4_LEFT:int = new int(Keyboard.F);
		public static const PLAYER4_RIGHT:int = new int(Keyboard.H);
		public static const PLAYER4_UP:int = new int(Keyboard.T);
		public static const PLAYER4_DOWN:int = new int(Keyboard.G);
		public static const PLAYER4_ACTION1:int = new int(Keyboard.R);
		public static const PLAYER4_ACTION2:int = new int(Keyboard.Y);
		
		public static const PLAYER1_COLOR:uint = new uint(0x313232);
		public static const PLAYER2_COLOR:uint = new uint(0x27ADE3);
		public static const PLAYER3_COLOR:uint = new uint(0xEE368A);
		public static const PLAYER4_COLOR:uint = new uint(0xB0D136);
		
		private static var local:Boolean = new Boolean(false);
		
		public function ChainJam() 
		{
			
		}
		
		/**
		 * Must be called when the game launches.  
		 */
		public static function init():void
		{
			try { ExternalInterface.call("GameStart"); }
			catch (e:Error) {
				trace("Can not communicate with browser. Assuming local game.")
				local = true;
			}
		}
		
		/**
		 * Add points to a player. Note: Once added, points can't be subtracted. 
		 * @param player
		 * Select which player to award points to. (1-4)
		 * @param points
		 * Select how many points that player get. 
		 */
		public static function addPoints(player:int, points:int):void 
		{
			if(!local){
				switch(player) {
					case 1: ExternalInterface.call("PlayerOnePoints(" + points +")"); break;
					case 2: ExternalInterface.call("PlayerTwoPoints(" + points +")"); break;
					case 3: ExternalInterface.call("PlayerThreePoints(" + points +")"); break;
					case 4: ExternalInterface.call("PlayerFourPoints(" + points +")"); break;
				}
			}
		}
		
		/**
		 * Only call once the game is complete. Will terminate your game and move on to the next. 
		 */
		public static function endGame():void 
		{
			if(!local){
				ExternalInterface.call("GameEnd");
			}
		}
	}
}