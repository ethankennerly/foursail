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
        private static var scoreVelocityY:Number = -150;

        internal var windRotation:Number;
        internal var boatAcceleration:Number;
        internal var boatSpeed:Number;
        internal var boatRotation:Number;
        internal var boatX:Number;
        internal var boatY:Number;
        internal var scoreY:Number;
        internal var headsailRotation:Number;
        internal var mainsailRotation:Number;
        internal var rudderRotation:Number;
        internal var worldOriginRotation:Number;

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
            windRotation = boat.wind.rotation + boat.rotation;
            headsailRotation = boat.headsail.rotation;
            mainsailRotation = boat.mainsail.rotation;
            rudderRotation = boat.rudder.rotation;
            boatRotationAcceleration = 0.0;
            boatRotationVelocity = 0.0;
            scoreY = -120.0;
            boatX = boat.x;
            boatY = boat.y;
            boatAcceleration = 0.01;
            boatSpeed = 0.0;
            worldOriginRotation = screen.world.boat.rotation;
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
            updateScore();
            updateView();
        }

        private function updateInput():void
        {
            if (true == input.keys[ChainJam.PLAYER1_LEFT]) {
                rudderRotation += elapsed * rotationElapsed;
            }
            if (true == input.keys[ChainJam.PLAYER1_RIGHT]) {
                rudderRotation -= elapsed * rotationElapsed;
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

        /**
         * 13/9/25 Mark Palange expects to sail faster away from the wind perpendicular to start line.
         */
        private function updatePhysics():void
        {
            var elapsedPortion:Number = elapsed / 100.0 * 3;
            var drag:Number = boatSpeed * elapsedPortion;
            var wind:Number = Math.abs(Math.cos(deg2rad(modRotation(windRotation - boatRotation))));
            var mainWind:Number = Math.abs(Math.cos(deg2rad(modRotation(windRotation - boatRotation))));
            boatAcceleration = Math.max(-0.1 * boatSpeed, boatAcceleration - drag + wind);
            boatSpeed += boatAcceleration * elapsedPortion;
            rudderRotation = clampRotation(rudderRotation);
            boatRotationAcceleration = -rudderRotation * rudderAcceleration * Math.max(0.1, boatSpeed) * elapsed / 33.3;
            boatRotationVelocity += boatRotationAcceleration;
            boatRotation += boatRotationVelocity;
            boatRotation = modRotation(boatRotation);
            boatX += boatSpeed * Math.cos(deg2rad(boatRotation)) * elapsedPortion;
            boatY += boatSpeed * Math.sin(deg2rad(boatRotation)) * elapsedPortion;
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
            boat.wind.rotation = windRotation - boat.rotation;
        }

        private function deg2rad(degree:Number):Number
        {
            return degree / 180.0 * Math.PI;
        }
        
        private function updateScore():void
        {
            if (boatY < scoreY) {
                scoreY += scoreVelocityY;
                trace("score at " + scoreY);
                Main.score(1);
                Main.score(2);
                Main.score(3);
                Main.score(4);
            }
        }
    }
}
