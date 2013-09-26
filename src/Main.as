package 
{
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.TimerEvent;
    import flash.geom.Point;
    import flash.utils.Timer;
    
    /**
     * Copied from
     * @author Norwigi
     */
    public class Main extends Sprite 
    {
        [Embed(source = "../bin/foursail_assets.swf", symbol = "Screen")] 
        internal static var Screen:Class;
        private var input:Input;
        private var model:Model;
        private var screen:*;
        
        //Self explanatory. Game will stop when gameOver == true.
        public static var gameOver:Boolean = new Boolean(false);
        
        //The maximum number of points allowed is 10. We need to keep track of that to be able to say when to end the game.
        public static var totalPoints:int = new int(0); 
        
        public function Main():void 
        {
            if (stage) init();
            else addEventListener(Event.ADDED_TO_STAGE, init);
        }
        
        private function init(e:Event = null):void 
        {
            removeEventListener(Event.ADDED_TO_STAGE, init);
            
            ChainJam.init();
            screen = new Screen();
            input = new Input(stage);
            model = new Model(screen, input);
            addChild(screen);
        }
        
        public static function score(pl:int):void {
            if (totalPoints < 10) {
                ChainJam.addPoints(pl, 1);
                totalPoints++;
                trace(totalPoints);
            }
            if (10 <= totalPoints) {
                ChainJam.endGame();
                gameOver = true;
            }
        }
    }
}
