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
@NeverlangUnit(language = StructuredQueryLang.class)
public class AppTest {
    @Test
    void testReturnsTable(@NeverlangUnitParam(source = "CREATE TABLE Panetteria(nomePane string, qtKg double)") ASTNode node) {
        var table = node.getAttributes().get("table");
        assertInstanceOf(Table.class, table);
        assertEquals("Panetteria", ((Table) table).getName());
    }

    @Test
    void testReturnsCorrectVariables(@NeverlangUnitParam(source = "CREATE TABLE Panetteria(nomePane string, qtKg double)") ASTNode node) {
        var table = node.getAttributes().get("table");
        assertInstanceOf(Table.class, table);
        assertEquals("Panetteria", ((Table) table).getName());
        assertEquals(List.of("nomePane","qtKg"), ((Table) table).getVars());
    }
}
