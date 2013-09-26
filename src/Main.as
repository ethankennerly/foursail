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
        
        //Setting the players
        public var player1:Player = new Player(1);
        public var player2:Player = new Player(2);
        public var player3:Player = new Player(3);
        public var player4:Player = new Player(4);
        
        //Self explanatory. Game will stop when gameOver == true.
        public static var gameOver:Boolean = new Boolean(false);
        
        //The maximum number of points allowed is 10. We need to keep track of that to be able to say when to end the game.
        public static var totalPoints:int = new int(0); 
        
        //Just some constants that define the size of different elements.
        public static const border:int = new int(30);
        public static const goalSize:int = new int(150);
        
        //Managing the cool-down for the action button.
        private var cooldownTimer:Timer = new Timer(3000, 1);
        private var actionReady:Boolean = new Boolean(true);
        
        //Variables to manage the random effects that take place when hitting the action button.
        public static var magnetic:Boolean = new Boolean(true);
        public static var selfMove:Boolean = new Boolean(false);
        public static var inverseX:Boolean = new Boolean(false);
        public static var inverseY:Boolean = new Boolean(false);
        public static var playerSpeedBoost:Boolean = new Boolean(false);
        public static var playerStopOnRelease:Boolean = new Boolean(true);
        
        
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
            /*-
            // entry point
            
            graphics.beginFill(0x000000);
            graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
            graphics.endFill();
            graphics.lineStyle(2, 0xFFFFFF);
            graphics.moveTo(border, border);
            graphics.lineTo(stage.stageWidth - border,border);
            graphics.lineTo(stage.stageWidth- border, stage.stageHeight-border);
            graphics.lineTo(border, stage.stageHeight-border);
            graphics.lineTo(border, border);
            
            addChild(player1);
            addChild(player2);
            addChild(player3);
            addChild(player4);
            
            var i:int = new int(1000)
            while(i!=0){
                addChild(new TargetObject());
                i--;
            }
            cooldownTimer.addEventListener(TimerEvent.TIMER, actionCooldown);
            -*/
        }
        
        public function capture(pl:int):void {
            switch(pl) {
                case 1: 
                    player1.capture();
                break;
                case 2: 
                    player2.capture();
                break;
                case 3: 
                    player3.capture();
                break;
                case 4: 
                    player4.capture();
                break;
            }
            addChild(new TargetObject());
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
        
        public function action():void {
            if (actionReady) {
                actionReady = false;
                cooldownTimer.start();
                var i:int;
                
                switch(randomRange(1,16)) {
                    case 1: magnetic = switchBoolean(magnetic); break;
                    case 2: 
                        i = 0;
                        while (i != numChildren) {
                            if (getChildAt(i) is TargetObject) {
                                getChildAt(i).x = stage.stageWidth / 2;
                                getChildAt(i).y = stage.stageHeight / 2;
                            }
                            i++;
                        }
                    break;
                    case 3: 
                        i = 0;
                        while (i != numChildren) {
                            if (getChildAt(i) is TargetObject) {
                                TargetObject(getChildAt(i)).makeBlack()
                            }
                            i++;
                        }
                    break;
                    case 4: 
                        i = 0;
                        while (i != numChildren) {
                            if (getChildAt(i) is TargetObject) {
                                TargetObject(getChildAt(i)).replace()
                            }
                            i++;
                        }
                    break;
                    case 5:selfMove
                        var playerArray:Array = randomArray(new Array(1, 2, 3, 4));
                        switchPlayers(playerArray[0], playerArray[1]);
                        switchPlayers(playerArray[2], playerArray[3]);
                    break;
                    case 6:
                        selfMove = switchBoolean(selfMove);
                    break;
                    case 7:
                        inverseY = switchBoolean(inverseY);
                    break;
                    case 8:
                        inverseX = switchBoolean(inverseX);
                    break;
                    case 9:
                        playerSpeedBoost = switchBoolean(playerSpeedBoost);
                    break;
                    case 10:
                        playerStopOnRelease = switchBoolean(playerStopOnRelease);
                    break;
                    case 11:
                        addChild(new Oneliner());
                    break;
                    case 12:
                        addChild(new Oneliner());
                    break;
                    case 13:
                        addChild(new Oneliner());
                    break;
                    case 14:
                        addChild(new Oneliner());
                    break;
                    default:
                        trace("Nothing happened");
                    break;
                }
            }
        }
        
        private function actionCooldown(e:TimerEvent):void {
            actionReady = true;
            cooldownTimer.stop();
            cooldownTimer.reset();
        }
        
        private function randomArray(inc:Array):Array {
            var out:Array = new Array();
             
            while (inc.length != 0) {
                var random:int = randomRange(0, inc.length-1);
                out.push(inc[random]);
                inc.splice(random, 1);
            }
            return out;
        }
        
        public static function randomRange(minNum:Number, maxNum:Number):Number 
        {
            return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
        }
        
        //Functions from here on down are just to make the randomize look prettier.
        
        private function switchPlayers(p1:int, p2:int):void 
        {
            var tempPoss:Point;
            var tempPlayer1:Player;
            var tempPlayer2:Player;
            if (p1 == 1) {tempPlayer1 = player1; }
            if(p1 == 2){tempPlayer1 = player2; }
            if(p1 == 3){tempPlayer1 = player3; }
            if(p1 == 4){tempPlayer1 = player4; }
            if (p2 == 1) { tempPlayer2 = player1 };
            if (p2 == 2) { tempPlayer2 = player2 };
            if (p2 == 3) { tempPlayer2 = player3 };
            if (p2 == 4) { tempPlayer2 = player4 };
            tempPoss = new Point(tempPlayer1.playerObject.x, tempPlayer1.playerObject.y);
            tempPlayer1.playerObject.x = tempPlayer2.playerObject.x;
            tempPlayer1.playerObject.y = tempPlayer2.playerObject.y;
            tempPlayer2.playerObject.x = tempPoss.x;
            tempPlayer2.playerObject.y = tempPoss.y;
        }
        
        private function switchBoolean(bool:Boolean):Boolean
        {
            if (bool == false) { return true; }
            else { return false; };
        }
    }
}
