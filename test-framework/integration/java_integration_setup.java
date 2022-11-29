/**
 * Summary:
 *  This script is written to reset the integration test
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

public class SharedMemoryIntegrationSetup {
    private static final Path libraryPath = Path.of("./shared_memory.dll");
    private static final Path counterPath = Path.of("./test-framework/integration/integration_test_counter");
    private static final SharedMemory sharedMemory = new SharedMemory(libraryPath);
    private static long numberOfSoftware = 5;

    public static void main(String[] args) throws InterruptedException, IOException {

        if (args.length > 0) {
            try {
                numberOfSoftware = Integer.parseInt(args[0]);
                System.out.println("numberOfSoftware = " + numberOfSoftware);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        sharedMemory.setSharedMemoryPath(counterPath);
        sharedMemory.setSharedMemoryData(new long[] {numberOfSoftware},false);
    }
}
