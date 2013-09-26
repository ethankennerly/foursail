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
        private static var rudderAcceleration:Number = 0.0002;

        internal var windRotation:Number;
        internal var boatSpeed:Number;
        internal var boatRotation:Number;
        internal var boatX:Number;
        internal var boatY:Number;
        internal var headsailRotation:Number;
        internal var mainsailRotation:Number;
        internal var rudderRotation:Number;
        internal var worldOriginRotation:Number;
        internal var worldOriginX:Number;
        internal var worldOriginY:Number;

        private var boatRotationAcceleration:Number;
        private var boatRotationVelocity:Number;

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
            windRotation = boat.wind.rotation;
            headsailRotation = boat.headsail.rotation;
            mainsailRotation = boat.mainsail.rotation;
            rudderRotation = boat.rudder.rotation;
            boatRotationAcceleration = 0.0;
            boatRotationVelocity = 0.0;
            boatX = boat.x;
            boatY = boat.y;
            boatSpeed = 0.0;
            worldOriginRotation = screen.world.boat.rotation;
            worldOriginX = screen.world.x;
            worldOriginY = screen.world.y;
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
            updateInput();
            updatePhysics();
            updateView();
        }

        private function updateInput():void
        {
            if (true == input.keys[ChainJam.PLAYER1_LEFT]) {
                rudderRotation -= elapsed * rotationElapsed;
            }
            if (true == input.keys[ChainJam.PLAYER1_RIGHT]) {
                rudderRotation += elapsed * rotationElapsed;
            }
            if (true == input.keys[ChainJam.PLAYER2_LEFT]) {
                mainsailRotation += elapsed * rotationElapsed;
            }
            if (true == input.keys[ChainJam.PLAYER2_RIGHT]) {
                mainsailRotation -= elapsed * rotationElapsed;
            }
            if (true == input.keys[ChainJam.PLAYER3_RIGHT]
             || true == input.keys[ChainJam.PLAYER3_LEFT]) {
                headsailRotation += elapsed * rotationElapsed;
            }
            if (true == input.keys[ChainJam.PLAYER4_RIGHT]
             || true == input.keys[ChainJam.PLAYER4_LEFT]) {
                headsailRotation -= elapsed * rotationElapsed;
            }
        }

        private function updatePhysics():void
        {
            boatSpeed = 0.05;  // debug updateWorldView
                        // 0.2;
            rudderRotation = clampRotation(rudderRotation);
            boatRotationAcceleration = -rudderRotation * rudderAcceleration * boatSpeed;
            boatRotationVelocity += boatRotationAcceleration;
            boatRotation += boatRotationVelocity;
            boatRotation = modRotation(boatRotation);
            boatX += boatSpeed * Math.cos(deg2rad(boatRotation));
            boatY += boatSpeed * Math.sin(deg2rad(boatRotation));
        }

        private function clampRotation(rotation:Number):Number
        {
            rotation = modRotation(rotation);
            var maxRotation:int = 45.0;
            if (rotation < -maxRotation) {
                rotation = -maxRotation;
            }
            else if (maxRotation < rotation) {
                rotation = maxRotation;
            }
            return rotation;
        }

        private function modRotation(rotation:Number):Number
        {
            if (isNaN(rotation)) {
                throw new Error("Expected rotation is a number " + rotation);
            }
            while (rotation < -180.0) {
                rotation += 360.0;
            }
            while (180.0 < rotation) {
                rotation -= 360.0;
            }
            return rotation;
        }

        private function updateView():void
        {
            screen.map.boat.rotation = boatRotation;
            screen.map.boat.x = boatX;
            screen.map.boat.y = boatY;
            updateBoatView(screen.map.boat);
            updateWorldView();
            updateBoatView(screen.world.boat);
        }

        /**
         * Relative to the boat.
         */
        private function updateWorldView():void
        {
            screen.world.environment.x = -boatX;
            screen.world.environment.y = -boatY;
            screen.world.rotation = worldOriginRotation - boatRotation;
            screen.world.boat.rotation = boatRotation;
        }

        /**
         * Relative to the map or world.
         */
        private function updateBoatView(boat:*):void
        {
            boat.rudder.rotation = rudderRotation;
            boat.mainsail.rotation = mainsailRotation;
            boat.headsail.rotation = headsailRotation;
        }

        private function deg2rad(degree:Number):Number
        {
            return degree / 180.0 * Math.PI;
        }
    }
}
