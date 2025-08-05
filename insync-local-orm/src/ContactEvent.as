package
{
	import flash.events.Event;

	public class ContactEvent extends Event
	{
		public static const CREATE:String = "create_contact";
		public static const UPDATE:String = "update_contact";
		public static const DELETE:String = "delete_contact";

		public var contact:Object;
		
		public function ContactEvent(type:String, contact:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}