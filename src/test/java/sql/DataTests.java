package sql;

import static org.junit.jupiter.api.Assertions.*;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.PrintStream;
import java.net.URISyntaxException;
import java.net.URL;

import neverlang.junit.NeverlangExt;
import neverlang.junit.NeverlangUnit;
import neverlang.junit.NeverlangUnitParam;
import neverlang.runtime.ASTNode;
import neverlang.runtime.Language;
import neverlang.utils.FileUtils;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;

/**
 * Test class for the data operations in SQLang.
 */
@ExtendWith(NeverlangExt.class)
@NeverlangUnit(language = SQLang.class)
public class DataTests {
    /**
     * The language tested.
     */
    private static final Language lang = new SQLang();

    /**
     * Get the AST node from a resource file.
     * @param language the language
     * @param file the file path
     * @return the AST node
     */
    private ASTNode getASTNodeFromResourceFile(Language language, String file) {
        try {
            File resourceFile = this.getResourceFile(file);
            String testFile = resourceFile.getAbsolutePath();
            String source = FileUtils.fileToString(testFile);
            return language.exec(source, resourceFile);
        } catch (IOException | URISyntaxException e) {
            Assertions.fail("Loading resource raised Exception " + e);
            return null;
        }
    }

    /**
     * Get the file from the resources folder.
     * @param file the file path
     * @return the file
     * @throws URISyntaxException if the URI is invalid
     */
    private File getResourceFile(String file) throws URISyntaxException {
        URL url = Thread.currentThread().getContextClassLoader().getResource(file);
        return new File(url.toURI());
    }

    /**
     * Test the output of a file.
     * @param file the file path
     * @param expectedOutput the expected output
     */
    private void testOutput(String file, String expectedOutput) {
        PrintStream originalOut = System.out;
        ByteArrayOutputStream outContent = new ByteArrayOutputStream();
        System.setOut(new PrintStream(outContent));

        try {
            ASTNode node = getASTNodeFromResourceFile(lang, file);
            assertNotNull(node);
            assertEquals(
                expectedOutput + "\n",
                outContent.toString()
            );
        } finally {
            System.setOut(originalOut);
        }
    }

    /**
     * Test if values are inserted into the database.
     * @param node the root of the AST
     */
    @Test
    void testInsertInto(@NeverlangUnitParam(files = "sql/values.sql") ASTNode node) {
        var db = node.getAttributes().get("db");
        assertNotNull(node);
        assertInstanceOf(DatabaseMap.class, db);
    }

    /**
     * Test the select operation.
     */
    @Test
    void testSelect() {
        testOutput(
            "sql/select.sql",
            "{EventName=Summer Picnic, MaxAttendees=100}\n" + //
            "{EventName=Tech Conference, MaxAttendees=300}\n" + //
            "{EventName=Charity Gala, MaxAttendees=200}\n" + //
            "{EventName=Holiday Party, MaxAttendees=150}\n" + //
            "\n" + //
            "{EventID=1, EventName=Summer Picnic, Location=Central Park, Organizer=Company Events Team, MaxAttendees=100, IsCancelled=false}\n" + //
            "{EventID=2, EventName=Tech Conference, Location=Convention Center, Organizer=Tech Group, MaxAttendees=300, IsCancelled=false}\n" + //
            "{EventID=3, EventName=Charity Gala, Location=Grand Hotel Ball room, Organizer=Local Charity Foundation, MaxAttendees=200, IsCancelled=true}\n" + //
            "{EventID=4, EventName=Holiday Party, Location=Office Headquarters, Organizer=HR Department, MaxAttendees=150, IsCancelled=false}\n");
    }

    /**
     * Test update and delete operations.
     */
    @Test
    void testDataManagement() {
        testOutput(
            "sql/data-management.sql",
            "{EventID=1, EventName=Summer Picnic, Location=Central Park, Organizer=Company Events Team, MaxAttendees=100, IsCancelled=false}\n" + //
            "{EventID=2, EventName=Tech Conference, Location=Convention Center, Organizer=Tech Group, MaxAttendees=300, IsCancelled=false}\n" + //
            "{EventID=3, EventName=Charity Gala, Location=Grand Hotel Ball room, Organizer=Local Charity Foundation, MaxAttendees=150, IsCancelled=true}\n" + //
            "{EventID=4, EventName=Holiday Party, Location=Office Headquarters, Organizer=null, MaxAttendees=150, IsCancelled=false}\n" + //
            "\n" + //
            "{EventID=1, EventName=Summer Picnic, Location=Central Park, Organizer=Company Events Team, MaxAttendees=100, IsCancelled=false}\n" + //
            "{EventID=2, EventName=Tech Conference, Location=Convention Center, Organizer=Tech Group, MaxAttendees=300, IsCancelled=false}\n" + //
            "{EventID=3, EventName=Charity Gala, Location=Grand Hotel Ball room, Organizer=Local Charity Foundation, MaxAttendees=150, IsCancelled=false}\n");
    }

    /**
     * Test data operations, such as where, order by and boolean operations.
     */
    @Test
    void testDataOperations() {
        testOutput(
            "sql/data-operations.sql",
            "{BookID=4, Title=1984, Author=George Orwell, Year=1949, Price=14.99, Available=true}\n" + //
            "{BookID=2, Title=Cento Anni di Solitudine, Author=Gabriel Garcia Marquez, Year=1967, Price=12.5, Available=true}\n" + //
            "{BookID=5, Title=Il Grande Gatsby, Author=F Scott Fitzgerald, Year=1925, Price=10.99, Available=false}\n" + //
            "{BookID=1, Title=Il Nome della Rosa, Author=Umberto Eco, Year=1980, Price=null, Available=true}\n" + //
            "{BookID=3, Title=Il Signore degli Anelli, Author=JRR Tolkien, Year=1954, Price=null, Available=false}\n" + //
            "\n" + //
            "{BookID=2, Title=Cento Anni di Solitudine, Author=Gabriel Garcia Marquez, Year=1967, Price=12.5, Available=true}\n" + //
            "{BookID=4, Title=1984, Author=George Orwell, Year=1949, Price=14.99, Available=true}\n" + //
            "\n" + //
            "{BookID=1, Title=Il Nome della Rosa, Author=Umberto Eco, Year=1980, Price=null, Available=true}\n" + //
            "{BookID=2, Title=Cento Anni di Solitudine, Author=Gabriel Garcia Marquez, Year=1967, Price=12.5, Available=true}\n" + //
            "{BookID=3, Title=Il Signore degli Anelli, Author=JRR Tolkien, Year=1954, Price=null, Available=false}\n" + //
            "\n" + //
            "{BookID=1, Title=Il Nome della Rosa, Author=Umberto Eco, Year=1980, Price=null, Available=true}\n" + //
            "\n" + //
            "{BookID=3, Title=Il Signore degli Anelli, Author=JRR Tolkien, Year=1954, Price=null, Available=false}\n" + //
            "{BookID=1, Title=Il Nome della Rosa, Author=Umberto Eco, Year=1980, Price=null, Available=true}\n" + //
            "{BookID=5, Title=Il Grande Gatsby, Author=F Scott Fitzgerald, Year=1925, Price=10.99, Available=false}\n" + //
            "{BookID=2, Title=Cento Anni di Solitudine, Author=Gabriel Garcia Marquez, Year=1967, Price=12.5, Available=true}\n" + //
            "{BookID=4, Title=1984, Author=George Orwell, Year=1949, Price=14.99, Available=true}\n");
    }

    /**
     * Test the aggregation operations (count, sum, avg, min, max) used with group by.
     */
    @Test
    void testAggregation() {
        testOutput(
            "sql/aggregation.sql",
            "{genre=Rock, COUNT(*)=5}\n" + //
            "{genre=Pop, COUNT(*)=3}\n" + //
            "{genre=Reggae, COUNT(*)=1}\n" + //
            "\n" + //
            "{artist=The Beatles, AVG(price)=19.99}\n" + //
            "{artist=Pink Floyd, AVG(price)=21.99}\n" + //
            "{artist=Michael Jackson, AVG(price)=17.323333333333334}\n" + //
            "{artist=Led Zeppelin, AVG(price)=21.99}\n" + //
            "{artist=Bob Marley, AVG(price)=17.99}\n" + //
            "{artist=Elvis Presley, AVG(price)=16.99}\n" + //
            "\n" + //
            "{album=Abbey Road, MAX(price)=19.99}\n" + //
            "{album=The Dark Side of the Moon, MAX(price)=24.99}\n" + //
            "{album=Thriller, MAX(price)=14.99}\n" + //
            "{album=Led Zeppelin IV, MAX(price)=21.99}\n" + //
            "{album=Legend, MAX(price)=17.99}\n" + //
            "{album=Wish You Were Here, MAX(price)=18.99}\n" + //
            "{album=Elvis Presley, MAX(price)=16.99}\n" + //
            "{album=Bad, MAX(price)=12.99}\n" + //
            "{album=Dangerous, MAX(price)=23.99}\n" + //
            "\n" + //
            "{genre=Rock, MIN(price)=16.99}\n" + //
            "{genre=Pop, MIN(price)=12.99}\n" + //
            "{genre=Reggae, MIN(price)=17.99}\n" + //
            "\n" + //
            "{artist=The Beatles, SUM(price)=19.99}\n" + //
            "{artist=Pink Floyd, SUM(price)=43.98}\n" + //
            "{artist=Michael Jackson, SUM(price)=51.97}\n" + //
            "{artist=Led Zeppelin, SUM(price)=21.99}\n" + //
            "{artist=Bob Marley, SUM(price)=17.99}\n" + //
            "{artist=Elvis Presley, SUM(price)=16.99}\n" + //
            "\n" + //
            "{artist=The Beatles, COUNT(*)=1}\n" + //
            "{artist=Pink Floyd, COUNT(*)=2}\n" + //
            "{artist=Led Zeppelin, COUNT(*)=1}\n" + //
            "{artist=Bob Marley, COUNT(*)=1}\n" + //
            "{artist=Elvis Presley, COUNT(*)=1}\n" + //
            "{artist=Michael Jackson, COUNT(*)=1}\n");
    }
}
