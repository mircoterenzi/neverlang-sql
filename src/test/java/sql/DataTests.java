package sql;

import static org.junit.jupiter.api.Assertions.*;

import neverlang.junit.NeverlangExt;
import neverlang.junit.NeverlangUnit;
import neverlang.junit.NeverlangUnitParam;
import neverlang.runtime.ASTNode;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;

/**
 * Test class for the data operations in SQLang.
 */
@ExtendWith(NeverlangExt.class)
@NeverlangUnit(language = SQLang.class)
public class DataTests {

    /**
     * Test if values are inserted into the database.
     * @param node the root of the AST
     */
    @Test
    void testInsertInto(@NeverlangUnitParam(files = "sql/values.sql") ASTNode node) {
        var db = node.getAttributes().get("db");
        assertInstanceOf(DatabaseMap.class, db);
    }

    /**
     * Test the select operation.
     * @param node the root of the AST
     */
    @Test   //TODO: test could be improved by checking the output on the stdout.
    void testSelect(@NeverlangUnitParam(files = "sql/select.sql") ASTNode node) { }

    /**
     * Test update and delete operations.
     * @param node the root of the AST
     */
    @Test
    void testDataManagement(@NeverlangUnitParam(files = "sql/data-management.sql") ASTNode node) { }

    /**
     * Test data operations, such as where, order by and boolean operations.
     * @param node the root of the AST
     */
    @Test
    void testDataOperations(@NeverlangUnitParam(files = "sql/data-operations.sql") ASTNode node) { }

    /**
     * Test the aggregation operations (count, sum, avg, min, max) used with group by.
     * @param node the root of the AST
     */
    @Test
    void testAggregation(@NeverlangUnitParam(files = "sql/aggregation.sql") ASTNode node) { }
}
