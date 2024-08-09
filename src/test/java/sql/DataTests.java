package sql;

import java.util.List;
import java.util.stream.Collectors;
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
                List.of(1, "Il Nome della Rosa", "Umberto Eco", 1980, 19.99f, true),
                List.of(2, "Cento Anni di Solitudine", "Gabriel Garcia Marquez", 1967, 12.50f, true),
                List.of(3, "Il Signore degli Anelli", "JRR Tolkien", 1954, 25.00f, false),
                List.of(4, "1984", "George Orwell", 1949, 14.99f, true),
                List.of(5, "Il Grande Gatsby", "F Scott Fitzgerald", 1925, 10.99f, false)
            ),
            db.get("Book").selectAll().stream()
                    .map(row -> List.of(row.get("BookID"), row.get("Title"), row.get("Author"), row.get("Year"), row.get("Price"), row.get("Available")))
                    .collect(Collectors.toList())
        );
    }

    @Test
    void testSelectColumn(@NeverlangUnitParam(files = "sql/select-column.sql") ASTNode node) {
        DatabaseMap db = (DatabaseMap) node.getAttributes().get("db");
        assertEquals(
            List.of(
            List.of("Summer Picnic", 100),
            List.of("Tech Conference", 300),
            List.of("Charity Gala", 200),
            List.of("Holiday Party", 150)
            ),
            db.get("EventDetails").selectAll().stream()
                .map(row -> List.of(row.get("EventName"), row.get("MaxAttendees")))
                .collect(Collectors.toList())
        );
    }
}
