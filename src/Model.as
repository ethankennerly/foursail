package  
{
    import flash.events.Event;
    import flash.utils.getTimer;

    /**
     * Sail boat with wind
     * @author Ethan Kennerly
     */
    public class Model 
    {
        private static var rotationElapsed:Number = 0.05;

        internal var windRotation:Number;
        internal var boatRotation:Number;
        internal var headsailRotation:Number;
        internal var mainsailRotation:Number;
        internal var rudderRotation:Number;

        internal var now:int;
        internal var previous:int;
        internal var elapsed:int;

        /**
         * Dynamic so don't need to specify properties.
         */
        internal var screen:*;
        internal var input:Input;

        public function Model(screen:*, input:Input) 
        {
            this.screen = screen;
            this.input = input;
            var boat:* = screen.map.boat;
            boatRotation = boat.rotation;
            windRotation = boat.wind.rotation - boatRotation;
            headsailRotation = boat.headsail.rotation - boatRotation;
            mainsailRotation = boat.mainsail.rotation - boatRotation;
            rudderRotation = boat.rudder.rotation - boatRotation;
            now = previous = getTimer();
            elapsed = 0;
            screen.addEventListener(Event.ENTER_FRAME, update, false, 0, true);
        }

        private function updateTime():void
        {
            previous = now;
            now = getTimer();
            elapsed = now - previous;
        }

        private function update(e:Event=null):void
        {
            updateTime();
            if (true == input.keys[ChainJam.PLAYER1_LEFT]) {
                rudderRotation -= elapsed * rotationElapsed;
            }
            if (true == input.keys[ChainJam.PLAYER1_RIGHT]) {
                rudderRotation += elapsed * rotationElapsed;
            }
            updateBoatView(screen.map.boat);
            updateBoatView(screen.world.boat);
        }

        private function updateBoatView(boat:*):void
        {
            boat.rudder.rotation = rudderRotation + boatRotation;
        }
    }
}
