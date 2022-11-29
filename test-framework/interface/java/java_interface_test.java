/**
 * Summary:
 *  This script is written to test the interface of SharedMemory library written for Java
 *
 * Author: Benyamin Izadpanah
 * Copyright: Benyamin Izadpanah
 * Github Repository: https://github.com/ben-izd/shared_memory
 * Start Date: 2022-8
 * Last date modified: 2022-11
 * Version used for testing: JDK 19
 * 
 * Version Requirement: JDK 19
 * */


import com.github.ben_izd.shared_memory.SharedMemory;
import org.junit.jupiter.api.*;
import java.io.IOException;
import java.nio.file.Path;
import java.util.Arrays;

import static org.junit.jupiter.api.Assertions.*;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class java_interface_test {

    private static SharedMemory library;

    private static final Path libraryPath = Path.of("./shared_memory.dll");
    private static final Path dataPath = Path.of( "./test-framework/interface/java/java_interface_test_data");

    @BeforeAll
    public static void setup(){
        library = new SharedMemory(libraryPath);
    }

    @AfterAll
    public static void close() throws IOException {
        library.close();
    }


    @Test
    @Order(1)
    @DisplayName("Utilities 1")
    public void Utilities1(){
        assertThrowsExactly(IllegalStateException.class,() -> library.getSharedMemoryRank() );
        assertThrowsExactly(IllegalStateException.class,() -> library.getSharedMemoryFlattenLength() );
        assertThrowsExactly(IllegalStateException.class,() -> library.getSharedMemoryByte2D() );
        assertThrowsExactly(IllegalStateException.class,() -> library.getSharedMemoryByte3D() );
        assertThrowsExactly(IllegalStateException.class,() -> library.getSharedMemoryByte4D() );
        assertThrowsExactly(IllegalStateException.class,() -> library.getSharedMemoryDimension() );
        assertThrowsExactly(IllegalStateException.class,() -> library.getSharedMemoryDataType() );
        assertThrowsExactly(IllegalStateException.class,() -> library.getSharedMemoryFlattenDataByte() );
        assertThrowsExactly(IllegalStateException.class,() -> library.getSharedMemoryFlattenDataInt() );
        assertThrowsExactly(IllegalStateException.class,() -> library.getSharedMemoryFlattenDataLong() );
        assertThrowsExactly(IllegalStateException.class,() -> library.getSharedMemoryFlattenDataShort() );
        assertThrowsExactly(IllegalStateException.class,() -> library.getSharedMemoryInt3D() );
        assertThrowsExactly(IllegalStateException.class,() -> library.getSharedMemoryInt2D() );
        assertThrowsExactly(IllegalStateException.class,() -> library.getSharedMemoryLong3D() );
        assertThrowsExactly(IllegalStateException.class,() -> library.getSharedMemoryLong2D() );
        assertThrowsExactly(IllegalStateException.class,() -> library.getSharedMemoryShort3D() );
        assertThrowsExactly(IllegalStateException.class,() -> library.getSharedMemoryShort2D() );

    }

    @Test
    @Order(2)
    public void setPath(){
        library.setSharedMemoryPath(dataPath);
    }

    @Test
    @Order(3)
    public void simpleByteTest(){
        var tempData = new byte[]{7, 8, 9, 10, 11, 12, 13};
        library.setSharedMemoryData(tempData);
        assertEquals(library.getSharedMemoryRank(), 1);
        assertEquals(library.getSharedMemoryFlattenLength(), 7);
        assertArrayEquals(library.getSharedMemoryDimension(),new long[]{7});
        assertEquals(library.getSharedMemoryDataType(), SharedMemory.SharedMemoryDataType.BYTE);
        assertArrayEquals(library.getSharedMemoryFlattenDataByte(), new byte[]{7, 8, 9, 10, 11, 12, 13});
    }

    @Test
    @Order(4)
    public void simpleShortTest(){
        var tempData = new short[]{7, 8, 9, 10, 11, 12, 13};
        library.setSharedMemoryData(tempData);
        assertEquals(library.getSharedMemoryRank(),1);
        assertEquals(library.getSharedMemoryFlattenLength(),7);
        assertArrayEquals(library.getSharedMemoryDimension(),new long[]{7});
        assertEquals(library.getSharedMemoryDataType(), SharedMemory.SharedMemoryDataType.SHORT);
        assertArrayEquals(library.getSharedMemoryFlattenDataShort(), new short[]{7, 8, 9, 10, 11, 12, 13});
    }

    @Test
    @Order(5)
    public void simpleIntTest(){
        var tempData = new int[]{7, 8, 9, 10, 11, 12, 13};
        library.setSharedMemoryData(tempData);
        assertEquals(library.getSharedMemoryRank(),1);
        assertEquals(library.getSharedMemoryFlattenLength(),7);
        assertArrayEquals(library.getSharedMemoryDimension(),new long[]{7});
        assertEquals(library.getSharedMemoryDataType(), SharedMemory.SharedMemoryDataType.INT);
        assertArrayEquals(library.getSharedMemoryFlattenDataInt(), new int[]{7, 8, 9, 10, 11, 12, 13});
    }

    @Test
    @Order(5)
    public void simpleLongTest(){
        var tempData = new long[]{7, 8, 9, 10, 11, 12, 13};
        library.setSharedMemoryData(tempData);
        assertEquals(library.getSharedMemoryRank(),1);
        assertEquals(library.getSharedMemoryFlattenLength(),7);
        assertArrayEquals(library.getSharedMemoryDimension(),new long[]{7});
        assertEquals(library.getSharedMemoryDataType(), SharedMemory.SharedMemoryDataType.LONG);
        assertArrayEquals(library.getSharedMemoryFlattenDataLong(), new long[]{7, 8, 9, 10, 11, 12, 13});
    }

    @Test
    @Order(6)
    public void simpleByte2DTest(){
        var tempData = new byte[][]{{8, 9, 5, 1, 6}, {10, 5, 5, 9, 9}, {8, 9, 7, 1, 7}};
        library.setSharedMemoryData(tempData,true);
        assertEquals(library.getSharedMemoryRank(),2);
        assertEquals(library.getSharedMemoryFlattenLength(),15);
        assertArrayEquals(library.getSharedMemoryDimension(),new long[]{3,5});
        assertEquals(library.getSharedMemoryDataType(), SharedMemory.SharedMemoryDataType.BYTE);
        assertArrayEquals(library.getSharedMemoryFlattenDataByte(), new byte[]{8,10,8,9,5,9,5,5,7,1,9,1,6,9,7});
        assertTrue(Arrays.deepEquals(library.getSharedMemoryByte2D(), new byte[][]{{8, 9, 5, 1, 6}, {10, 5, 5, 9, 9}, {8, 9, 7, 1, 7}}));
    }

    @Test
    @Order(7)
    public void simpleShort2DTest(){
        var tempData = new short[][]{{8, 9, 5, 1, 6}, {10, 5, 5, 9, 9}, {8, 9, 7, 1, 7}};
        library.setSharedMemoryData(tempData,true);
        assertEquals(library.getSharedMemoryRank(),2);
        assertEquals(library.getSharedMemoryFlattenLength(),15);
        assertArrayEquals(library.getSharedMemoryDimension(),new long[]{3,5});
        assertEquals(library.getSharedMemoryDataType(), SharedMemory.SharedMemoryDataType.SHORT);
        assertArrayEquals(library.getSharedMemoryFlattenDataShort(), new short[]{8,10,8,9,5,9,5,5,7,1,9,1,6,9,7});
        assertTrue(Arrays.deepEquals(library.getSharedMemoryShort2D(), new short[][]{{8, 9, 5, 1, 6}, {10, 5, 5, 9, 9}, {8, 9, 7, 1, 7}}));
    }

    @Test
    @Order(8)
    public void simpleInt2DTest(){
        var tempData = new int[][]{{8, 9, 5, 1, 6}, {10, 5, 5, 9, 9}, {8, 9, 7, 1, 7}};
        library.setSharedMemoryData(tempData,true);
        assertEquals(library.getSharedMemoryRank(),2);
        assertEquals(library.getSharedMemoryFlattenLength(),15);
        assertArrayEquals(library.getSharedMemoryDimension(),new long[]{3,5});
        assertEquals(library.getSharedMemoryDataType(), SharedMemory.SharedMemoryDataType.INT);
        assertArrayEquals(library.getSharedMemoryFlattenDataInt(), new int[]{8,10,8,9,5,9,5,5,7,1,9,1,6,9,7});
        assertTrue(Arrays.deepEquals(library.getSharedMemoryInt2D(), new int[][]{{8, 9, 5, 1, 6}, {10, 5, 5, 9, 9}, {8, 9, 7, 1, 7}}));
    }


    @Test
    @Order(9)
    public void simpleLong2DTest(){
        var tempData = new long[][]{{8, 9, 5, 1, 6}, {10, 5, 5, 9, 9}, {8, 9, 7, 1, 7}};
        library.setSharedMemoryData(tempData,true);
        assertEquals(library.getSharedMemoryRank(),2);
        assertEquals(library.getSharedMemoryFlattenLength(),15);
        assertArrayEquals(library.getSharedMemoryDimension(),new long[]{3,5});
        assertEquals(library.getSharedMemoryDataType(), SharedMemory.SharedMemoryDataType.LONG);
        assertArrayEquals(library.getSharedMemoryFlattenDataLong(), new long[]{8,10,8,9,5,9,5,5,7,1,9,1,6,9,7});
        assertTrue(Arrays.deepEquals(library.getSharedMemoryLong2D(), new long[][]{{8, 9, 5, 1, 6}, {10, 5, 5, 9, 9}, {8, 9, 7, 1, 7}}));
    }

    @Test
    @Order(10)
    public void simpleByte3DTest(){
        var tempData = new byte[][][]{{{8,10,7,3,5},{5,10,1,1,3},{6,7,8,3,4},{2,10,5,1,8}},{{8,3,1,1,10},{4,8,4,5,9},{2,3,5,2,9},{10,1,2,4,2}},{{7,8,10,5,10},{10,4,6,6,8},{2,3,8,2,8},{6,10,5,4,9}}};
        library.setSharedMemoryData(tempData,true);
        assertEquals(library.getSharedMemoryRank(),3);
        assertEquals(library.getSharedMemoryFlattenLength(),60);
        assertArrayEquals(library.getSharedMemoryDimension(),new long[]{4, 5, 3});
        assertEquals(library.getSharedMemoryDataType(), SharedMemory.SharedMemoryDataType.BYTE);
        assertArrayEquals(library.getSharedMemoryFlattenDataByte(), new byte[]{8,5,6,2,10,10,7,10,7,1,8,5,3,1,3,1,5,3,4,8,8,4,2,10,3,8,3,1,1,4,5,2,1,5,2,4,10,9,9,2,7,10,2,6,8,4,3,10,10,6,8,5,5,6,2,4,10,8,8,9});
        assertTrue(Arrays.deepEquals(library.getSharedMemoryByte3D(), new byte[][][]{{{8,10,7,3,5},{5,10,1,1,3},{6,7,8,3,4},{2,10,5,1,8}},{{8,3,1,1,10},{4,8,4,5,9},{2,3,5,2,9},{10,1,2,4,2}},{{7,8,10,5,10},{10,4,6,6,8},{2,3,8,2,8},{6,10,5,4,9}}}));
    }

    @Test
    @Order(11)
    public void simpleShort3DTest(){
        var tempData = new short[][][]{{{8,10,7,3,5},{5,10,1,1,3},{6,7,8,3,4},{2,10,5,1,8}},{{8,3,1,1,10},{4,8,4,5,9},{2,3,5,2,9},{10,1,2,4,2}},{{7,8,10,5,10},{10,4,6,6,8},{2,3,8,2,8},{6,10,5,4,9}}};
        library.setSharedMemoryData(tempData,true);
        assertEquals(library.getSharedMemoryRank(),3);
        assertEquals(library.getSharedMemoryFlattenLength(),60);
        assertArrayEquals(library.getSharedMemoryDimension(),new long[]{4, 5, 3});
        assertEquals(library.getSharedMemoryDataType(), SharedMemory.SharedMemoryDataType.SHORT);
        assertArrayEquals(library.getSharedMemoryFlattenDataShort(), new short[]{8,5,6,2,10,10,7,10,7,1,8,5,3,1,3,1,5,3,4,8,8,4,2,10,3,8,3,1,1,4,5,2,1,5,2,4,10,9,9,2,7,10,2,6,8,4,3,10,10,6,8,5,5,6,2,4,10,8,8,9});
        assertTrue(Arrays.deepEquals(library.getSharedMemoryShort3D(), new short[][][]{{{8,10,7,3,5},{5,10,1,1,3},{6,7,8,3,4},{2,10,5,1,8}},{{8,3,1,1,10},{4,8,4,5,9},{2,3,5,2,9},{10,1,2,4,2}},{{7,8,10,5,10},{10,4,6,6,8},{2,3,8,2,8},{6,10,5,4,9}}}));
    }

    @Test
    @Order(12)
    public void simpleInt3DTest(){
        var tempData = new int[][][]{{{8,10,7,3,5},{5,10,1,1,3},{6,7,8,3,4},{2,10,5,1,8}},{{8,3,1,1,10},{4,8,4,5,9},{2,3,5,2,9},{10,1,2,4,2}},{{7,8,10,5,10},{10,4,6,6,8},{2,3,8,2,8},{6,10,5,4,9}}};
        library.setSharedMemoryData(tempData,true);
        assertEquals(library.getSharedMemoryRank(),3);
        assertEquals(library.getSharedMemoryFlattenLength(),60);
        assertArrayEquals(library.getSharedMemoryDimension(),new long[]{4, 5, 3});
        assertEquals(library.getSharedMemoryDataType(), SharedMemory.SharedMemoryDataType.INT);
        assertArrayEquals(library.getSharedMemoryFlattenDataInt(), new int[]{8,5,6,2,10,10,7,10,7,1,8,5,3,1,3,1,5,3,4,8,8,4,2,10,3,8,3,1,1,4,5,2,1,5,2,4,10,9,9,2,7,10,2,6,8,4,3,10,10,6,8,5,5,6,2,4,10,8,8,9});
        assertTrue(Arrays.deepEquals(library.getSharedMemoryInt3D(), new int[][][]{{{8,10,7,3,5},{5,10,1,1,3},{6,7,8,3,4},{2,10,5,1,8}},{{8,3,1,1,10},{4,8,4,5,9},{2,3,5,2,9},{10,1,2,4,2}},{{7,8,10,5,10},{10,4,6,6,8},{2,3,8,2,8},{6,10,5,4,9}}}));
    }

    @Test
    @Order(13)
    public void simpleLong3DTest(){
        var tempData = new long[][][]{{{8,10,7,3,5},{5,10,1,1,3},{6,7,8,3,4},{2,10,5,1,8}},{{8,3,1,1,10},{4,8,4,5,9},{2,3,5,2,9},{10,1,2,4,2}},{{7,8,10,5,10},{10,4,6,6,8},{2,3,8,2,8},{6,10,5,4,9}}};
        library.setSharedMemoryData(tempData,true);
        assertEquals(library.getSharedMemoryRank(),3);
        assertEquals(library.getSharedMemoryFlattenLength(),60);
        assertArrayEquals(library.getSharedMemoryDimension(),new long[]{4, 5, 3});
        assertEquals(library.getSharedMemoryDataType(), SharedMemory.SharedMemoryDataType.LONG);
        assertArrayEquals(library.getSharedMemoryFlattenDataLong(), new long[]{8,5,6,2,10,10,7,10,7,1,8,5,3,1,3,1,5,3,4,8,8,4,2,10,3,8,3,1,1,4,5,2,1,5,2,4,10,9,9,2,7,10,2,6,8,4,3,10,10,6,8,5,5,6,2,4,10,8,8,9});
        assertTrue(Arrays.deepEquals(library.getSharedMemoryLong3D(), new long[][][]{{{8,10,7,3,5},{5,10,1,1,3},{6,7,8,3,4},{2,10,5,1,8}},{{8,3,1,1,10},{4,8,4,5,9},{2,3,5,2,9},{10,1,2,4,2}},{{7,8,10,5,10},{10,4,6,6,8},{2,3,8,2,8},{6,10,5,4,9}}}));
    }

    @Test
    @Order(14)
    public void simpleStringTest(){
        var tempData = "Java 😍 JDK 😉 java 😁";
        library.setSharedMemoryData(tempData);
        assertEquals(library.getSharedMemoryRank(),1);
        assertEquals(library.getSharedMemoryFlattenLength(),28);
        assertArrayEquals(library.getSharedMemoryDimension(),new long[]{28});
        assertEquals(library.getSharedMemoryDataType(), SharedMemory.SharedMemoryDataType.STRING);
        assertEquals(library.getSharedMemoryString(), tempData);
    }

    @Test
    @Order(15)
    public void utility2(){
        library.deleteSharedMemory();
        assertFalse(dataPath.toFile().exists());
        library.setSharedMemoryData(new int[]{1});
        assertTrue(dataPath.toFile().exists());
        dataPath.toFile().delete();
        assertThrows(RuntimeException.class,() -> library.getSharedMemoryRank());
        assertThrows(RuntimeException.class,() -> library.getSharedMemoryFlattenLength());
        assertThrows(RuntimeException.class,() -> library.getSharedMemoryDimension());
        assertThrows(RuntimeException.class,() -> library.getSharedMemoryDataType());
        assertThrows(RuntimeException.class,() -> library.getSharedMemoryFlattenDataLong());
        assertThrows(RuntimeException.class,() -> library.getSharedMemoryInt3D());
    }
}
