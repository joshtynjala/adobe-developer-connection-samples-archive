package
{
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	
	public class ContactDAO implements IContactDAO
	{
		private var stmtFindAll:SQLStatement;
		private var stmtInsert:SQLStatement;
		private var stmtUpdate:SQLStatement;
		private var stmtUpdatePicture:SQLStatement;
		private var stmtDelete:SQLStatement;
		
		public function ContactDAO(sqlConnection:SQLConnection)
		{
			// Prepare the findAll statement
			stmtFindAll = new SQLStatement();
			stmtFindAll.sqlConnection = sqlConnection;
			stmtFindAll.text = "SELECT * FROM CONTACT";

			// Prepare the insert statement
			stmtInsert = new SQLStatement();
			stmtInsert.sqlConnection = sqlConnection;
			stmtInsert.text = 
				"INSERT INTO contact (first_name, last_name, address, city, state, zip, phone, email) " +
					"VALUES (:firstName, :lastName, :address, :city, :state, :zip, :phone, :email)"; 
			
			// Prepare the update statement
			stmtUpdate = new SQLStatement();
			stmtUpdate.sqlConnection = sqlConnection;
			stmtUpdate.text = 
				"UPDATE contact set " + 
					"first_name=:firstName, " + 
					"last_name=:lastName, " +
					"address=:address, " +
					"city=:city, " +
					"state=:state, " +
					"zip=:zip, " +
					"phone=:phone, " +
					"email=:email " +
					"WHERE contact_id=:contactId";

			// Prepare the update picture statement
			stmtUpdatePicture = new SQLStatement();
			stmtUpdatePicture.sqlConnection = sqlConnection;
			stmtUpdatePicture.text = "UPDATE contact set pic=:jpeg WHERE contact_id=:contactId";

			// Prepare the delete statement
			stmtDelete = new SQLStatement();
			stmtDelete.sqlConnection = sqlConnection;
			stmtDelete.text = "DELETE FROM contact WHERE contact_id = :contactId";
		}
		
		public function findAll():ArrayCollection
		{
			stmtFindAll.execute();
			return new ArrayCollection(stmtFindAll.getResult().data);
		}
		
		public function insert(contact:Object):void
		{
			stmtInsert.parameters[":firstName"] = contact.first_name; 
			stmtInsert.parameters[":lastName"] = contact.last_name; 
			stmtInsert.parameters[":address"] = contact.address; 
			stmtInsert.parameters[":city"] = contact.city; 
			stmtInsert.parameters[":state"] = contact.state; 
			stmtInsert.parameters[":zip"] = contact.zip; 
			stmtInsert.parameters[":email"] = contact.email; 
			stmtInsert.parameters[":phone"] = contact.phone; 
			stmtInsert.execute();
			contact.contact_id = stmtInsert.getResult().lastInsertRowID;
		}
		
		public function update(contact:Object):void
		{
			stmtUpdate.parameters[":firstName"] = contact.first_name; 
			stmtUpdate.parameters[":lastName"] = contact.last_name; 
			stmtUpdate.parameters[":address"] = contact.address; 
			stmtUpdate.parameters[":city"] = contact.city; 
			stmtUpdate.parameters[":state"] = contact.state; 
			stmtUpdate.parameters[":zip"] = contact.zip; 
			stmtUpdate.parameters[":phone"] = contact.phone; 
			stmtUpdate.parameters[":email"] = contact.email; 
			stmtUpdate.parameters[":contactId"] = contact.contact_id; 
			stmtUpdate.execute();
		}

		public function updatePicture(contactId:int, jpeg:ByteArray):void
		{
			stmtUpdatePicture.parameters[":jpeg"] = jpeg; 
			stmtUpdatePicture.parameters[":contactId"] = contactId; 
			stmtUpdatePicture.execute();
		}

		public function deleteItem(contact:Object):void
		{
			stmtDelete.parameters[":contactId"] = contact.contact_id; 
			stmtDelete.execute();
		}

	}
}