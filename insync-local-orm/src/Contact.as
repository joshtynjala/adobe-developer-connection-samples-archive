package
{
	import flash.utils.ByteArray;
	
	[Bindable]
	[Table(name="contact")]
	public class Contact
	{
		[Id]
		[Column(name="contact_id")]
		public var contactId:int;

		[Column(name="first_name")]
		public var firstName:String;

		[Column(name="last_name")]
		public var lastName:String;
		public var address:String;
		public var city:String;
		public var state:String;
		public var zip:String;
		public var phone:String;
		public var email:String;
		public var pic:ByteArray;
	}
}