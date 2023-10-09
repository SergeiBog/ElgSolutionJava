package Task_2_2_1;

import java.io.IOException;

public class RunnerThisTask {
    public static void main(String[] args){
        ZipFile zipFile = new ZipFile();
        String root = zipFile.getAbsolutePath();
        String name = zipFile.getNameForZipFile();
        zipFile.Zip(root,name);
        SendEmail sendEmail = new SendEmail();
        sendEmail.sendEmail(root + "/",name + ".zip");
    }
}
