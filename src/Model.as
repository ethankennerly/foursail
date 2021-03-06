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
        private static var rudderAcceleration:Number = 0.0004;
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
        internal var start:int;
        internal var frameTime:int;

        /**
         * Dynamic so don't need to specify properties.
         */
        internal var screen:*;
        internal var input:Input;
        private var hudToggled:Boolean;

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
            now = previous = start = getTimer();
            frameTime = 0;
            screen.hud.visible = false;
            hudToggled = false;
            screen.score.text = "0";
            screen.addEventListener(Event.ENTER_FRAME, update, false, 0, true);
        }

        private function updateTime():void
        {
            previous = now;
            now = getTimer();
            frameTime = now - previous;
            var timeLimit:int = 60;
            var minute:int = (timeLimit / 60) - (now - start) / 60000;
            var seconds:int = timeLimit - ((now - start) % 60000) / 1000;
            screen.time.text = minute.toString() + ":" + (seconds < 10 ? "0" : "") + seconds;
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
                rudderRotation += frameTime * rotationElapsed;
            }
            if (true == input.keys[ChainJam.PLAYER1_RIGHT]) {
                rudderRotation -= frameTime * rotationElapsed;
            }
            if (true == input.keys[ChainJam.PLAYER2_LEFT]) {
                mainsailRotation += frameTime * rotationElapsed;
            }
            if (true == input.keys[ChainJam.PLAYER2_RIGHT]) {
                mainsailRotation -= frameTime * rotationElapsed;
            }
            if (true == input.keys[ChainJam.PLAYER3_RIGHT]
             || true == input.keys[ChainJam.PLAYER3_LEFT]) {
                headsailRotation += frameTime * rotationElapsed;
            }
            if (true == input.keys[ChainJam.PLAYER4_RIGHT]
             || true == input.keys[ChainJam.PLAYER4_LEFT]) {
                headsailRotation -= frameTime * rotationElapsed;
            }
            if (true == input.keys[ChainJam.PLAYER1_ACTION1]) {
                if (!hudToggled) {
                    screen.hud.visible = !screen.hud.visible;
                }
                hudToggled = true;
            }
            else {
                hudToggled = false;
            }
        }

        /**
         * 13/9/25 Mark Palange expects to sail faster away from the wind perpendicular to start line.
         * Mark expects slow to sail upwind. Faster to sail downwind.
         * 13/9/27 Eli Delventhal expects to multiply speed.
         */
        private function updatePhysics():void
        {
            headsailRotation = clampRotation(headsailRotation);
            mainsailRotation = clampRotation(mainsailRotation);
            var frameTimePortion:Number = frameTime / 100.0 * 3;
            var drag:Number = boatSpeed * frameTimePortion;
            var boatWindRotation:Number = modRotation(windRotation - boatRotation - 90.0);
            var wind:Number = 2 * Math.abs(Math.sin(deg2rad(boatWindRotation)));
            if (boatWindRotation > -135 || 135 < boatWindRotation) {
                wind /= 5.0;
            }
            else if (-45 < boatWindRotation && boatWindRotation < 45) {
                wind = Math.abs(wind);
            }
            screen.hud.wind.text = boatWindRotation.toFixed(0) + ": " + wind.toFixed(2);
            var optimalSailRotation:Number = 0.0;
                                             // -135.0;
            var mainsailWindRotation:Number = modRotation(windRotation - mainsailRotation - boatRotation - 90.0);
            if (boatWindRotation > -90 || boatWindRotation < 90) {
                if (-135 <= mainsailWindRotation && mainsailWindRotation <= 135) {
                    mainsailWindRotation /= 5.0;
                }
                if (-135 <= headsailWindRotation && headsailWindRotation <= 135) {
                    headsailWindRotation /= 5.0;
                }
            }
            var headsailWindRotation:Number = modRotation(windRotation - headsailRotation - boatRotation - 90.0);
            var mainsailWind:Number = 0.5 * Math.abs(Math.sin(deg2rad(modRotation(mainsailWindRotation + optimalSailRotation))));
            screen.hud.mainsailWind.text = mainsailWindRotation.toFixed(0) + ": " + mainsailWind.toFixed(2);
            var headsailWind:Number = 0.5 * Math.abs(Math.sin(deg2rad(modRotation(headsailWindRotation + optimalSailRotation))));
            boatAcceleration = Math.max(-0.1 * boatSpeed, boatAcceleration - drag + Math.min(wind, mainsailWind, headsailWind));
            var boatAccelerationMultiplier:Number = 4.0;
            boatAcceleration *= boatAccelerationMultiplier;
            if (boatWindRotation > -90 || boatWindRotation < 90) {
            }
            else {
                boatAcceleration *= 8.0;
            }
            if (boatX < -100 || 100 < boatX || boatY < -420 || 40 < boatY) {
                boatAcceleration *= 0.1;
            }
            boatSpeed += boatAcceleration * frameTimePortion;
            rudderRotation = clampRotation(rudderRotation);
            boatRotationAcceleration = -rudderRotation * rudderAcceleration * Math.max(0.1, boatSpeed) * frameTime / 33.3;
            var boatRotationAccelerationMax:Number = 0.01;
            boatRotationAcceleration = Math.max(-boatRotationAccelerationMax, Math.min(boatRotationAccelerationMax, boatRotationAcceleration));
            boatRotationVelocity += boatRotationAcceleration;
            boatRotation += boatRotationVelocity * frameTimePortion;
            boatRotation = modRotation(boatRotation);
            boatX += boatSpeed * Math.cos(deg2rad(boatRotation)) * frameTimePortion;
            boatY += boatSpeed * Math.sin(deg2rad(boatRotation)) * frameTimePortion;
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
                Main.score(1, screen);
                Main.score(2, screen);
                Main.score(3, screen);
                Main.score(4, screen);
            }
        }
    }
}
