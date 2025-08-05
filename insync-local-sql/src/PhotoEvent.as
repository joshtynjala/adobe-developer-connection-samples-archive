package
{
	import flash.events.Event;
	import flash.utils.ByteArray;

	public class PhotoEvent extends Event
	{
		public static const NEW_PHOTO:String = "new_photo";

		public var jpeg:ByteArray;
		
		public function PhotoEvent(type:String, jpeg:ByteArray, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.jpeg = jpeg; 
			super(type, bubbles, cancelable);
		}
		
	}
}