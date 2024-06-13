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
        Table table = (Table) node.getAttributes().get("table");
        assertEquals(List.of("nomePane", "qtKg"), table.getVars());
    }

    //todo: this text and the next one are done using the table obtained as output from the create table declaration (change to id)
    @Test
    void testAddColumnToTable(@NeverlangUnitParam(source = "ALTER TABLE CREATE TABLE Panetteria(nomePane string, qtKg double) ADD prezzoKg double") ASTNode node) {
        Table table = (Table) node.getAttributes().get("table");
        assertEquals(List.of("nomePane", "qtKg", "prezzoKg"), table.getVars());
    }

    @Test
    void testDropColumnToTable(@NeverlangUnitParam(source = "ALTER TABLE CREATE TABLE Panetteria(nomePane string, qtKg double) DROP qtKg") ASTNode node) {
        Table table = (Table) node.getAttributes().get("table");
        assertEquals(List.of("nomePane"), table.getVars());
    }
}
