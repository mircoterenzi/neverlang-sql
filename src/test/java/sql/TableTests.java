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
public class TableTests {
    @Test
    void testReturnsDB(@NeverlangUnitParam(source = "CREATE TABLE Product (" +
                "ProductID INT," +
                "ProductName VARCHAR(100)," +
                "Price FLOAT," +
                "InStock BOOLEAN" +
                ");") ASTNode node) {
        var db = node.getAttributes().get("db");
        assertInstanceOf(DatabaseMap.class, db);
        assertTrue(((DatabaseMap) db).containsKey("Product"));
    }

    @Test
    void testReturnsCorrectVariables(@NeverlangUnitParam(source = "CREATE TABLE Product (" +
                "ProductID INT," +
                "ProductName VARCHAR(100)," +
                "Price FLOAT," +
                "InStock BOOLEAN" +
                ");") ASTNode node) {
        DatabaseMap db = (DatabaseMap) node.getAttributes().get("db");
        assertEquals(
            List.of("ProductID","ProductName","Price","InStock"), 
            db.get("Product").getColumnNames()
        );
    }

    @Test
    void testAddColumn(@NeverlangUnitParam(files = "sql/add-col.sql") ASTNode node) {
        DatabaseMap db = (DatabaseMap) node.getAttributes().get("db");
        assertEquals(
            List.of("DepartmentID","DepartmentName","ManagerName","Budget"), 
            db.get("Department").getColumnNames()
        );
    }

    @Test
    void testDropColumn(@NeverlangUnitParam(files = "sql/drop-col.sql") ASTNode node) {
        DatabaseMap db = (DatabaseMap) node.getAttributes().get("db");
        assertEquals(List.of("EmployeeID","FirstName","LastName"), db.get("Employee").getColumnNames());
    }

    @Test
    void testDropTable(@NeverlangUnitParam(files = "sql/drop-table.sql") ASTNode node) {
        DatabaseMap db = (DatabaseMap) node.getAttributes().get("db");
        assertFalse(db.containsKey("Product"));
    }

    @Test
    void testMultiple(@NeverlangUnitParam(files = "sql/multiple-operations.sql") ASTNode node) {
        DatabaseMap db = (DatabaseMap) node.getAttributes().get("db");
        assertFalse(db.containsKey("Customer"));
        assertTrue(db.containsKey("Orders"));
        assertEquals(List.of("OrderID","CustomerID","ShippingAddress","OrderStatus"), db.get("Orders").getColumnNames());
    }
}
