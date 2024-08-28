package sql;

import java.util.List;
import neverlang.junit.NeverlangExt;
import neverlang.junit.NeverlangUnit;
import neverlang.junit.NeverlangUnitParam;
import neverlang.runtime.ASTNode;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Test class for the Table class.
 */
@ExtendWith(NeverlangExt.class)
@NeverlangUnit(language = SQLang.class)
public class TableTests {

    /**
     * Test case to verify that the table is added to the database correctly.
     * @param node the root of the AST
     */
    @Test
    void testReturnsDB(@NeverlangUnitParam(source = "CREATE TABLE Product (" +
                "   ProductID INT, " +
                "   ProductName VARCHAR(100), " +
                "   Price FLOAT, " +
                "   InStock BOOLEAN " +
                ");") ASTNode node) {
        var db = node.getAttributes().get("db");
        assertInstanceOf(DatabaseMap.class, db);
        assertTrue(((DatabaseMap) db).containsKey("Product"));
    }

    /**
     * Test case to verify that the table variables are correct.
     * @param node the root of the AST
     */
    @Test
    void testReturnsCorrectVariables(@NeverlangUnitParam(source = "CREATE TABLE Product (" +
                "ProductID INT, " +
                "ProductName VARCHAR(100), " +
                "Price FLOAT, " +
                "InStock BOOLEAN " +
                ");") ASTNode node) {
        DatabaseMap db = (DatabaseMap) node.getAttributes().get("db");
        assertEquals(
            List.of("ProductID","ProductName","Price","InStock"), 
            db.get("Product").getColumnNames()
        );
    }

    /**
     * Test case to verify that a column is added to the table correctly.
     * @param node the root of the AST
     */
    @Test
    void testAddColumn(@NeverlangUnitParam(source = "CREATE TABLE Department(" +
                "   DepartmentID INT, " + 
                "   DepartmentName VARCHAR(50) " +
                "); " +
                "ALTER TABLE Department " +
                "ADD ManagerName VARCHAR(50); " +
                "ALTER TABLE Department " +
                "ADD Budget FLOAT; ") ASTNode node) {
        DatabaseMap db = (DatabaseMap) node.getAttributes().get("db");
        assertEquals(
            List.of("DepartmentID","DepartmentName","ManagerName","Budget"), 
            db.get("Department").getColumnNames()
        );
    }

    /**
     * Test case to verify that a column is dropped from the table correctly.
     * @param node the root of the AST
     */
    @Test
    void testDropColumn(@NeverlangUnitParam(source = "CREATE TABLE Employee (" +
                "    EmployeeID INT, " +
                "    FirstName VARCHAR(50), " +
                "    LastName VARCHAR(50), " +
                "    Salary FLOAT" +
                ");" +
                "ALTER TABLE Employee " +
                "DROP Salary;") ASTNode node) {
        DatabaseMap db = (DatabaseMap) node.getAttributes().get("db");
        assertEquals(List.of("EmployeeID","FirstName","LastName"), db.get("Employee").getColumnNames());
    }

    /**
     * Test case to verify that a table is dropped from the database correctly.
     * @param node the root of the AST
     */
    @Test
    void testDropTable(@NeverlangUnitParam(source = "CREATE TABLE Product (" +
                "    ProductID INT, " +
                "    ProductName VARCHAR(100), " +
                "    Price FLOAT, " +
                "    InStock BOOLEAN " +
                ");" +
                "DROP TABLE Product;") ASTNode node) {
        DatabaseMap db = (DatabaseMap) node.getAttributes().get("db");
        assertFalse(db.containsKey("Product"));
    }

    /**
     * Test case to verify multiple SQL operations.
     * @param node the root of the AST
     */
    @Test
    void testMultiple(@NeverlangUnitParam(files = "sql/table.sql") ASTNode node) {
        DatabaseMap db = (DatabaseMap) node.getAttributes().get("db");
        assertFalse(db.containsKey("Customer"));
        assertTrue(db.containsKey("Orders"));
        assertEquals(List.of("OrderID","CustomerID","ShippingAddress","OrderStatus"), db.get("Orders").getColumnNames());
    }
}
