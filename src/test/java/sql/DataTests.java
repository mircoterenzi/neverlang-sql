package sql;

import java.util.List;
import neverlang.junit.NeverlangExt;
import neverlang.junit.NeverlangUnit;
import neverlang.junit.NeverlangUnitParam;
import neverlang.runtime.ASTNode;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;

import static org.junit.jupiter.api.Assertions.*;

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
        DatabaseMap db = (DatabaseMap) node.getAttributes().get("db");
        assertEquals(
            List.of(
                List.of(1, 2, 3, 4, 5),
                List.of("Il Nome della Rosa", "Cento Anni di Solitudine", "Il Signore degli Anelli", "1984", "Il Grande Gatsby"),
                List.of("Umberto Eco", "Gabriel Garcia Marquez", "JRR Tolkien", "George Orwell", "F Scott Fitzgerald"),
                List.of(1980, 1967, 1954, 1949, 1925),
                List.of(19.99f, 12.50f, 25.00f, 14.99f, 10.99f),
                List.of(Boolean.TRUE, Boolean.TRUE, Boolean.FALSE, Boolean.TRUE, Boolean.FALSE)
            ),
            db.get("Book").get()
        );
    }

    @Test
    void testSelectColumn(@NeverlangUnitParam(files = "sql/select-column.sql") ASTNode node) {
        DatabaseMap db = (DatabaseMap) node.getAttributes().get("db");
        assertEquals(
            List.of(
                List.of("Summer Picnic","Tech Conference","Charity Gala","Holiday Party"),
                List.of(100,300,200,150)
            ),
            db.get("EventDetails").get(List.of("EventName","MaxAttendees"))
        );
    }
}
