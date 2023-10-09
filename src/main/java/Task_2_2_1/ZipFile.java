package Task_2_2_1;


import java.io.*;
import java.nio.file.Paths;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

public class ZipFile {
    public String getAbsolutePath(){
        return Paths.get("").toAbsolutePath().toString();
    }
    public String getNameForZipFile(){
        return Paths.get("").toAbsolutePath().getFileName().toString();
    }
    public void Zip(String sourceDir, String zipFile){
        try(FileOutputStream fileOutputStream = new FileOutputStream(zipFile);
        ZipOutputStream zipOutputStream = new ZipOutputStream(fileOutputStream)){
            File file = new File(sourceDir);
            addDirectory(zipOutputStream, file);
        }catch (Exception e){
            e.printStackTrace();
        }
        System.out.println("Zip file was created");
    }
    private void addDirectory(ZipOutputStream zipOutputStream, File fileSource){
        File[] files = fileSource.listFiles();
        for(File file : files){
            if(file.isDirectory()) {
                addDirectory(zipOutputStream, file);
            }
            try (FileInputStream fileInputStream = new FileInputStream(file)){
                zipOutputStream.putNextEntry(new ZipEntry(file.getPath()));
                byte[] buffer = new byte[4048];
                int length;
                while ((length = fileInputStream.read(buffer))>0){
                    zipOutputStream.write(buffer,0,length);
                }
            }catch (Exception e){
                e.printStackTrace();
            }
        }
    }
}
