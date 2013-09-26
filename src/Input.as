package  
{
    import flash.display.Stage;
    import flash.events.KeyboardEvent;
    import flash.utils.Dictionary;

    /**
     * Keyboard input
     * @author Ethan Kennerly
     */
    public class Input
    {
        internal var keys:Dictionary = new Dictionary();

        public function Input(stage:Stage) 
        {
            stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed, false, 0, true);
            stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased, false, 0, true);
        }

        private function keyPressed(e:KeyboardEvent):void 
        {
            keys[e.keyCode] = true;
        }
        
        private function keyReleased(e:KeyboardEvent):void 
        {
            if (e.keyCode in keys) {
                delete keys[e.keyCode];
            }
        }
    }
}
