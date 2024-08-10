package sql;

import static org.junit.jupiter.api.Assertions.*;

import neverlang.junit.NeverlangExt;
import neverlang.junit.NeverlangUnit;
import neverlang.junit.NeverlangUnitParam;
import neverlang.runtime.ASTNode;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;


@ExtendWith(NeverlangExt.class)
@NeverlangUnit(language = SQLang.class)
public class DataTests {
    @Test
    void testInsertInto(@NeverlangUnitParam(files = "sql/insert-values.sql") ASTNode node) {
        var db = node.getAttributes().get("db");
        assertInstanceOf(DatabaseMap.class, db);
    }

    @Test
    void testSelectAll(@NeverlangUnitParam(files = "sql/select-all.sql") ASTNode node) {
        var db = (DatabaseMap) node.getAttributes().get("db");
        assertEquals( 
            "{BookID=1, Title=Il Nome della Rosa, Author=Umberto Eco, Year=1980, Price=19.99, Available=true}\n" + //
            "{BookID=2, Title=Cento Anni di Solitudine, Author=Gabriel Garcia Marquez, Year=1967, Price=12.5, Available=true}\n" + //
            "{BookID=3, Title=Il Signore degli Anelli, Author=JRR Tolkien, Year=1954, Price=25.0, Available=false}\n" + //
            "{BookID=4, Title=1984, Author=George Orwell, Year=1949, Price=14.99, Available=true}\n" + //
            "{BookID=5, Title=Il Grande Gatsby, Author=F Scott Fitzgerald, Year=1925, Price=10.99, Available=false}\n",
            db.get("OUTPUT").toString() //TODO: atm is a fake table, maybe it should check the output on the stdout.
        );
    }

    @Test
    void testSelectColumn(@NeverlangUnitParam(files = "sql/select-column.sql") ASTNode node) {
        var db = (DatabaseMap) node.getAttributes().get("db");
        assertEquals(
            "{EventID=1, EventName=Summer Picnic, Location=Central Park, Organizer=Company Events Team, MaxAttendees=100, IsCancelled=false}\n" + //
            "{EventID=2, EventName=Tech Conference, Location=Convention Center, Organizer=Tech Group, MaxAttendees=300, IsCancelled=false}\n" + //
            "{EventID=3, EventName=Charity Gala, Location=Grand Hotel Ball room, Organizer=Local Charity Foundation, MaxAttendees=200, IsCancelled=true}\n" + //
            "{EventID=4, EventName=Holiday Party, Location=Office Headquarters, Organizer=HR Department, MaxAttendees=150, IsCancelled=false}\n",
            db.get("EventDetails").toString()
        );
        assertEquals( 
            "{EventName=Summer Picnic, MaxAttendees=100}\n" + //
            "{EventName=Tech Conference, MaxAttendees=300}\n" + //
            "{EventName=Charity Gala, MaxAttendees=200}\n" + //
            "{EventName=Holiday Party, MaxAttendees=150}\n",
            db.get("OUTPUT").toString()
        );
    }
}
