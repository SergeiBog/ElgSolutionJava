package Task_2_2_1;

import java.io.IOException;

public class RunnerThisTask {
    public static void main(String[] args) throws IOException {
        ZipFile zipFile = new ZipFile();
        String root = zipFile.getAbsolutePath();
        String name = zipFile.getName();
        zipFile.zipDirectory(zipFile.getAbsolutePath());
        SendEmail sendEmail = new SendEmail();
        sendEmail.sendEmail(root + "/",name + ".zip");
    }
}
