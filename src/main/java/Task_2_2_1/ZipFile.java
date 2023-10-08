package Task_2_2_1;


import java.io.*;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

public class ZipFile {

    List<String> fileDirectory = new ArrayList<>();

    public String getAbsolutePath(){
        return Paths.get("").toAbsolutePath().toString();
    }

    public String getName(){
        return Paths.get("").toAbsolutePath().getFileName().toString();
    }

    public void zipDirectory(String directory) throws IOException {
        String root = this.getAbsolutePath();
        String fileZipName = this.getName();

        File file = new File(root);

        String zipFileDirectory = directory + "/" + fileZipName + ".zip";

        FileOutputStream fileOutputStream = new FileOutputStream(zipFileDirectory);
        ZipOutputStream zipOutputStream = new ZipOutputStream(fileOutputStream);
        addFileList(file);
        for (String path : fileDirectory) {
            ZipEntry zipEntry = new ZipEntry(path.substring(file.getAbsolutePath().length() + 1,
                    path.length()));
            zipOutputStream.putNextEntry(zipEntry);
            try (FileInputStream fileInputStream = new FileInputStream(path)) {
                byte[] buffer = new byte[1024];
                int len = fileInputStream.read(buffer);
                while (len > 0) {
                    zipOutputStream.write(buffer, 0, len);
                }
            }
        }
    }


    private void addFileList(File file) throws IOException{
        File[] files = file.listFiles();
        for(File nFile : Objects.requireNonNull(files)){
            if (nFile.isFile()){
                fileDirectory.add(nFile.getAbsolutePath());
            }else{
                addFileList(nFile);
            }
        }
    }
}
