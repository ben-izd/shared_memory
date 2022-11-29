/**
 * Summary:
 *  This script is written to test the integration of interface of SharedMemory library written for Java with other interfaces
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
import java.io.IOException;
import java.nio.file.Path;
import java.util.Arrays;

import static org.junit.jupiter.api.Assertions.*;

public class java_integration_test {
    private static long numberOfSoftware = 5;
    private static final Path libraryPath = Path.of("./shared_memory.dll");
    private static final Path dataPath = Path.of("./test-framework/integration/integration_test_data");
    private static final Path counterPath = Path.of("./test-framework/integration/integration_test_counter");
    private static final SharedMemory sharedMemory = new SharedMemory(libraryPath);
    private static final int[] dataset1 = new int[]{32, 46, 76, 12, 42};
    private static final int[][] dataset2 = new int[][]{{5, 9, 12}, {43, 21, 36}};
    private static final int[][][] dataset3 = new int[][][]{{{60, 68, 44, 31}, {109, 26, 25, 124}}, {{88, 18, 48, 39}, {52, 25, 87, 37}}, {{14, 67, 98, 125}, {80, 16, 22, 20}}};

    private static final int datasetsLength = 36;

    private static long getCounter() {
        sharedMemory.setSharedMemoryPath(counterPath);
        var output = sharedMemory.getSharedMemoryFlattenDataLong()[0];
        sharedMemory.setSharedMemoryPath(dataPath);
        //        System.out.println("output = " + output);
        return output;
    }

    private static void increment() {

        sharedMemory.setSharedMemoryPath(counterPath);
        long temp = sharedMemory.getSharedMemoryFlattenDataLong()[0];
        sharedMemory.setSharedMemoryData(new long[]{temp + 1L});
        System.out.printf("->%d%n", temp + 1);
        sharedMemory.setSharedMemoryPath(dataPath);
    }

    private static void reshare(long index) {

        reshare(index, true, true);
    }

    private static void reshare(long index, boolean flagCheckData, boolean flagShareData) {
        sharedMemory.setSharedMemoryPath(dataPath);

        switch ((int) index) {
            case 0 -> {

                var expected = new byte[dataset1.length];
                for (int i = 0; i < dataset1.length; i++) {
                    expected[i] = (byte) dataset1[i];
                }
                if (flagCheckData) {
                    var actual = sharedMemory.getSharedMemoryFlattenDataByte();
                    assertArrayEquals(actual, expected);
                }
                if (flagShareData)
                    sharedMemory.setSharedMemoryData(expected,false);
            }
            case 1 -> {
                var expected = new short[dataset1.length];
                for (int i = 0; i < dataset1.length; i++) {
                    expected[i] = (short) dataset1[i];
                }
                if (flagCheckData) {
                    var actual = sharedMemory.getSharedMemoryFlattenDataShort();
                    assertArrayEquals(actual, expected);
                }
                if (flagShareData)
                    sharedMemory.setSharedMemoryData(expected,false);
            }
            case 2 -> {
                var expected = new int[dataset1.length];
                for (int i = 0; i < dataset1.length; i++) {
                    expected[i] = (int) dataset1[i];
                }
                if (flagCheckData) {
                    var actual = sharedMemory.getSharedMemoryFlattenDataInt();
                    assertArrayEquals(actual, expected);
                }
                if (flagShareData)
                    sharedMemory.setSharedMemoryData(expected,false);
            }
            case 3 -> {
                var expected = new long[dataset1.length];
                for (int i = 0; i < dataset1.length; i++) {
                    expected[i] = (long) dataset1[i];
                }
                if (flagCheckData) {
                    var actual = sharedMemory.getSharedMemoryFlattenDataLong();
                    assertArrayEquals(actual, expected);
                }
                if (flagShareData)
                    sharedMemory.setSharedMemoryData(expected,false);
            }
            case 4 -> {
                var expected = new byte[dataset1.length];
                for (int i = 0; i < dataset1.length; i++) {
                    expected[i] = (byte) dataset1[i];
                }
                if (flagCheckData) {
                    var actual = sharedMemory.getSharedMemoryFlattenDataByte();
                    assertArrayEquals(actual, expected);
                }
                if (flagShareData)
                    sharedMemory.setSharedMemoryData(expected,true);
            }
            case 5 -> {
                var expected = new short[dataset1.length];
                for (int i = 0; i < dataset1.length; i++) {
                    expected[i] = (short) dataset1[i];
                }
                if (flagCheckData) {
                    var actual = sharedMemory.getSharedMemoryFlattenDataShort();
                    assertArrayEquals(actual, expected);
                }
                if (flagShareData)
                    sharedMemory.setSharedMemoryData(expected,true);
            }
            case 6 -> {
                var expected = new int[dataset1.length];
                for (int i = 0; i < dataset1.length; i++) {
                    expected[i] = (int) dataset1[i];
                }
                if (flagCheckData) {
                    var actual = sharedMemory.getSharedMemoryFlattenDataInt();
                    assertArrayEquals(actual, expected);
                }
                if (flagShareData)
                    sharedMemory.setSharedMemoryData(expected,true);
            }
            case 7 -> {
                var expected = new long[dataset1.length];
                for (int i = 0; i < dataset1.length; i++) {
                    expected[i] = (long) dataset1[i];
                }
                if (flagCheckData) {
                    var actual = sharedMemory.getSharedMemoryFlattenDataLong();
                    assertArrayEquals(actual, expected);
                }
                if (flagShareData)
                    sharedMemory.setSharedMemoryData(expected,true);
            }
            case 8 -> {
                var expected = new float[dataset1.length];
                for (int i = 0; i < dataset1.length; i++) {
                    expected[i] = (float) dataset1[i];
                }
                if (flagCheckData) {
                    var actual = sharedMemory.getSharedMemoryFlattenDataFloat();
                    assertArrayEquals(actual, expected);
                }
                if (flagShareData)
                    sharedMemory.setSharedMemoryData(expected);
            }
            case 9 -> {
                var expected = new double[dataset1.length];
                for (int i = 0; i < dataset1.length; i++) {
                    expected[i] = (double) dataset1[i];
                }
                if (flagCheckData) {
                    var actual = sharedMemory.getSharedMemoryFlattenDataDouble();
                    assertArrayEquals(actual, expected);
                }
                if (flagShareData)
                    sharedMemory.setSharedMemoryData(expected);
            }
            case 10 -> {
                // JAVA DOES NOT SUPPORT COMPLEX NUMBERS
                // DO NOTHING
            }
            case 11 -> {
                // JAVA DOES NOT SUPPORT COMPLEX NUMBERS
                // DO NOTHING
            }
            case 12 -> {
                var expected = new byte[dataset2.length][dataset2[0].length];
                for (int i = 0; i < dataset2.length; i++) {
                    for (int j = 0; j < dataset2[i].length; j++) {
                        expected[i][j] = (byte) dataset2[i][j];
                    }
                }
                if (flagCheckData) {
                    var actual = sharedMemory.getSharedMemoryByte2D();
                    assertTrue(Arrays.deepEquals(actual, expected));
                }
                if (flagShareData)
                    sharedMemory.setSharedMemoryData(expected,false);
            }
            case 13 -> {
                var expected = new short[dataset2.length][dataset2[0].length];
                for (int i = 0; i < dataset2.length; i++) {
                    for (int j = 0; j < dataset2[i].length; j++) {
                        expected[i][j] = (short) dataset2[i][j];
                    }
                }
                if (flagCheckData) {
                    var actual = sharedMemory.getSharedMemoryShort2D();
                    assertTrue(Arrays.deepEquals(actual, expected));
                }
                if (flagShareData)
                    sharedMemory.setSharedMemoryData(expected,false);
            }
            case 14 -> {
                var expected = new int[dataset2.length][dataset2[0].length];
                for (int i = 0; i < dataset2.length; i++) {
                    for (int j = 0; j < dataset2[i].length; j++) {
                        expected[i][j] = (int) dataset2[i][j];
                    }
                }
                if (flagCheckData) {
                    var actual = sharedMemory.getSharedMemoryInt2D();
                    assertTrue(Arrays.deepEquals(actual, expected));
                }
                if (flagShareData)
                    sharedMemory.setSharedMemoryData(expected,false);
            }
            case 15 -> {
                var expected = new long[dataset2.length][dataset2[0].length];
                for (int i = 0; i < dataset2.length; i++) {
                    for (int j = 0; j < dataset2[i].length; j++) {
                        expected[i][j] = (long) dataset2[i][j];
                    }
                }
                if (flagCheckData) {
                    var actual = sharedMemory.getSharedMemoryLong2D();
                    assertTrue(Arrays.deepEquals(actual, expected));
                }
                if (flagShareData)
                    sharedMemory.setSharedMemoryData(expected,false);
            }
            case 16 -> {
                var expected = new byte[dataset2.length][dataset2[0].length];
                for (int i = 0; i < dataset2.length; i++) {
                    for (int j = 0; j < dataset2[i].length; j++) {
                        expected[i][j] = (byte) dataset2[i][j];
                    }
                }
                if (flagCheckData) {
                    var actual = sharedMemory.getSharedMemoryByte2D();
                    assertTrue(Arrays.deepEquals(actual, expected));
                }
                if (flagShareData)
                    sharedMemory.setSharedMemoryData(expected,true);
            }
            case 17 -> {

                var expected = new short[dataset2.length][dataset2[0].length];
                for (int i = 0; i < dataset2.length; i++) {
                    for (int j = 0; j < dataset2[i].length; j++) {
                        expected[i][j] = (short) dataset2[i][j];
                    }
                }
                if (flagCheckData) {
                    var actual = sharedMemory.getSharedMemoryShort2D();
                    assertTrue(Arrays.deepEquals(actual, expected));
                }
                if (flagShareData)
                    sharedMemory.setSharedMemoryData(expected,true);
            }
            case 18 -> {
                var expected = new int[dataset2.length][dataset2[0].length];
                for (int i = 0; i < dataset2.length; i++) {
                    for (int j = 0; j < dataset2[i].length; j++) {
                        expected[i][j] = (int) dataset2[i][j];
                    }
                }
                if (flagCheckData) {
                    var actual = sharedMemory.getSharedMemoryInt2D();
                    assertTrue(Arrays.deepEquals(actual, expected));
                }
                if (flagShareData)
                    sharedMemory.setSharedMemoryData(expected,true);
            }
            case 19 -> {
                var expected = new long[dataset2.length][dataset2[0].length];
                for (int i = 0; i < dataset2.length; i++) {
                    for (int j = 0; j < dataset2[i].length; j++) {
                        expected[i][j] = (long) dataset2[i][j];
                    }
                }
                if (flagCheckData) {
                    var actual = sharedMemory.getSharedMemoryLong2D();
                    assertTrue(Arrays.deepEquals(actual, expected));
                }
                if (flagShareData)
                    sharedMemory.setSharedMemoryData(expected,true);
            }
            case 20 -> {
                var expected = new float[dataset2.length][dataset2[0].length];
                for (int i = 0; i < dataset2.length; i++) {
                    for (int j = 0; j < dataset2[i].length; j++) {
                        expected[i][j] = (float) dataset2[i][j];
                    }
                }
                if (flagCheckData) {
                    var actual = sharedMemory.getSharedMemoryFloat2D();
                    assertTrue(Arrays.deepEquals(actual, expected));
                }
                if (flagShareData)
                    sharedMemory.setSharedMemoryData(expected);
            }
            case 21 -> {
                var expected = new double[dataset2.length][dataset2[0].length];
                for (int i = 0; i < dataset2.length; i++) {
                    for (int j = 0; j < dataset2[i].length; j++) {
                        expected[i][j] = (double) dataset2[i][j];
                    }
                }
                if (flagCheckData) {
                    var actual = sharedMemory.getSharedMemoryDouble2D();
                    assertTrue(Arrays.deepEquals(actual, expected));
                }
                if (flagShareData)
                    sharedMemory.setSharedMemoryData(expected);
            }
            case 22 -> {
                // JAVA DOES NOT SUPPORT COMPLEX NUMBERS
                // DO NOTHING
            }
            case 23 -> {
                // JAVA DOES NOT SUPPORT COMPLEX NUMBERS
                // DO NOTHING
            }
            case 24 -> {
                var expected = new byte[dataset3.length][dataset3[0].length][dataset3[0][0].length];
                for (int i = 0; i < dataset3.length; i++) {
                    for (int j = 0; j < dataset3[i].length; j++) {
                        for (int k = 0; k < dataset3[i][j].length; k++)
                            expected[i][j][k] = (byte) dataset3[i][j][k];
                    }
                }
                if (flagCheckData) {
                    var actual = sharedMemory.getSharedMemoryByte3D();
                    assertTrue(Arrays.deepEquals(actual, expected));
                }
                if (flagShareData)
                    sharedMemory.setSharedMemoryData(expected,false);
            }
            case 25 -> {
                var expected = new short[dataset3.length][dataset3[0].length][dataset3[0][0].length];
                for (int i = 0; i < dataset3.length; i++) {
                    for (int j = 0; j < dataset3[i].length; j++) {
                        for (int k = 0; k < dataset3[i][j].length; k++)
                            expected[i][j][k] = (short) dataset3[i][j][k];
                    }
                }
                if (flagCheckData) {
                    var actual = sharedMemory.getSharedMemoryShort3D();
                    assertTrue(Arrays.deepEquals(actual, expected));
                }
                if (flagShareData)
                    sharedMemory.setSharedMemoryData(expected,false);
            }
            case 26 -> {
                var expected = new int[dataset3.length][dataset3[0].length][dataset3[0][0].length];
                for (int i = 0; i < dataset3.length; i++) {
                    for (int j = 0; j < dataset3[i].length; j++) {
                        for (int k = 0; k < dataset3[i][j].length; k++)
                            expected[i][j][k] = (int) dataset3[i][j][k];
                    }
                }
                if (flagCheckData) {
                    var actual = sharedMemory.getSharedMemoryInt3D();
                    assertTrue(Arrays.deepEquals(actual, expected));
                }
                if (flagShareData)
                    sharedMemory.setSharedMemoryData(expected,false);
            }
            case 27 -> {
                var expected = new long[dataset3.length][dataset3[0].length][dataset3[0][0].length];
                for (int i = 0; i < dataset3.length; i++) {
                    for (int j = 0; j < dataset3[i].length; j++) {
                        for (int k = 0; k < dataset3[i][j].length; k++)
                            expected[i][j][k] = (long) dataset3[i][j][k];
                    }
                }

                if (flagCheckData) {
                    var actual = sharedMemory.getSharedMemoryLong3D();
                    assertTrue(Arrays.deepEquals(actual, expected));
                }
                if (flagShareData)
                    sharedMemory.setSharedMemoryData(expected,false);
            }
            case 28 -> {
                var expected = new byte[dataset3.length][dataset3[0].length][dataset3[0][0].length];
                for (int i = 0; i < dataset3.length; i++) {
                    for (int j = 0; j < dataset3[i].length; j++) {
                        for (int k = 0; k < dataset3[i][j].length; k++)
                            expected[i][j][k] = (byte) dataset3[i][j][k];
                    }
                }
                if (flagCheckData) {
                    var actual = sharedMemory.getSharedMemoryByte3D();
                    assertTrue(Arrays.deepEquals(actual, expected));
                }
                if (flagShareData)
                    sharedMemory.setSharedMemoryData(expected,true);
            }
            case 29 -> {
                var expected = new short[dataset3.length][dataset3[0].length][dataset3[0][0].length];
                for (int i = 0; i < dataset3.length; i++) {
                    for (int j = 0; j < dataset3[i].length; j++) {
                        for (int k = 0; k < dataset3[i][j].length; k++)
                            expected[i][j][k] = (short) dataset3[i][j][k];
                    }
                }
                if (flagCheckData) {
                    var actual = sharedMemory.getSharedMemoryShort3D();
                    assertTrue(Arrays.deepEquals(actual, expected));
                }
                if (flagShareData)
                    sharedMemory.setSharedMemoryData(expected,true);
            }
            case 30 -> {
                var expected = new int[dataset3.length][dataset3[0].length][dataset3[0][0].length];
                for (int i = 0; i < dataset3.length; i++) {
                    for (int j = 0; j < dataset3[i].length; j++) {
                        for (int k = 0; k < dataset3[i][j].length; k++)
                            expected[i][j][k] = (int) dataset3[i][j][k];
                    }
                }
                if (flagCheckData) {
                    var actual = sharedMemory.getSharedMemoryInt3D();
                    assertTrue(Arrays.deepEquals(actual, expected));
                }
                if (flagShareData)
                    sharedMemory.setSharedMemoryData(expected,true);
            }
            case 31 -> {
                var expected = new long[dataset3.length][dataset3[0].length][dataset3[0][0].length];
                for (int i = 0; i < dataset3.length; i++) {
                    for (int j = 0; j < dataset3[i].length; j++) {
                        for (int k = 0; k < dataset3[i][j].length; k++)
                            expected[i][j][k] = (long) dataset3[i][j][k];
                    }
                }
                if (flagCheckData) {
                    var actual = sharedMemory.getSharedMemoryLong3D();
                    assertTrue(Arrays.deepEquals(actual, expected));
                }
                if (flagShareData)
                    sharedMemory.setSharedMemoryData(expected,true);
            }
            case 32 -> {
                var expected = new float[dataset3.length][dataset3[0].length][dataset3[0][0].length];
                for (int i = 0; i < dataset3.length; i++) {
                    for (int j = 0; j < dataset3[i].length; j++) {
                        for (int k = 0; k < dataset3[i][j].length; k++)
                            expected[i][j][k] = (float) dataset3[i][j][k];
                    }
                }
                if (flagCheckData) {
                    var actual = sharedMemory.getSharedMemoryFloat3D();
                    assertTrue(Arrays.deepEquals(actual, expected));
                }
                if (flagShareData)
                    sharedMemory.setSharedMemoryData(expected);
            }
            case 33 -> {
                var expected = new double[dataset3.length][dataset3[0].length][dataset3[0][0].length];
                for (int i = 0; i < dataset3.length; i++) {
                    for (int j = 0; j < dataset3[i].length; j++) {
                        for (int k = 0; k < dataset3[i][j].length; k++)
                            expected[i][j][k] = (double) dataset3[i][j][k];
                    }
                }
                if (flagCheckData) {
                    var actual = sharedMemory.getSharedMemoryDouble3D();
                    assertTrue(Arrays.deepEquals(actual, expected));
                }
                if (flagShareData)
                    sharedMemory.setSharedMemoryData(expected);
            }
            case 34 -> {
                // JAVA DOES NOT SUPPORT COMPLEX NUMBERS
                // DO NOTHING
            }
            case 35 -> {
                // JAVA DOES NOT SUPPORT COMPLEX NUMBERS
                // DO NOTHING
            }
        }
    }

    public static void main(String[] args) throws InterruptedException, IOException {

        if (args.length > 0) {
            try {
                numberOfSoftware = Integer.parseInt(args[0]);
                System.out.println("numberOfSoftware = " + numberOfSoftware);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        long counter = getCounter();
        long offset = counter % numberOfSoftware;
        long index;
        System.out.println("offset = " + offset);
        System.out.println("counter = " + counter);
        while (counter <= (36 * numberOfSoftware) + 1) {
            if ((counter - offset) % numberOfSoftware == 0) {
                index = ((counter - offset) / numberOfSoftware) - 1;
                if (offset != 0) {
                    reshare(index);
                } else {
                    if (index > 0 && index <= datasetsLength ) {
                        sharedMemory.setSharedMemoryPath(dataPath);
                        reshare(index-1, true, false);
                    }
                    if (index < datasetsLength) {
                        reshare(index, false, true);
                    }
                }
                increment();
            }
            System.out.print(".");
            Thread.sleep(50);
            counter = getCounter();
        }
        sharedMemory.close();
    }
}
