package  
{
    /**
     * Sail boat with wind
     * @author Ethan Kennerly
     */
    public class Model 
    {
        public function Model() 
        {
            internal var windRotation:Number;
            internal var keelRotation:Number;
            internal var headsailRotation:Number;
            internal var mainsailRotation:Number;
            internal var rudderRotation:Number;
            internal var nowMs:int;
            internal var previousMs:int;
            internal var elapsedMs:int;
        }
    }
}
