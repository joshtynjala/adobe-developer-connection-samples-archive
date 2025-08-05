package {
	
	// import the Event class so it can be extended
	import flash.events.Event;
	
	// define the BounceEvent class as a subclass of Event
	public class BounceEvent extends Event {
		
		// static BOUNCE constant used as an event type
		public static const BOUNCE:String = "bounce";
		
		// internal property defining side 
		private var _side:String = "none";
		
		// public read-only property for side
		public function get side():String {
			return _side;
		}
		
		// BounceEvent constructor used to create new bounce events
		// when created, the side being bounced should be passed after type
		public function BounceEvent(type:String, side:String){
			
			// call super (Event constructor) indicating
			// true for bubbles parameter
			super(type, true);
			
			// set side property
			_side = side;
		}
		
		// override clone method so that it can correctly
		// return a BounceEvent instance
		public override function clone():Event {
			return new BounceEvent(type, _side);
		}
	}
}