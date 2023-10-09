package Task_2_2_1;

import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.io.File;
import java.io.IOException;
import java.util.Properties;

public class SendEmail {

    private static final String EMAIL_FROM = "fromEmail@mail.ru";
    private static final String PASSWORD = "qwerty123";
    private static final String EMAIL_TO = "toEmail@mail.com";
    private static final String HOST = "localhost";

    public void sendEmail(String filePath, String fileName){
        Properties properties = System.getProperties();
        properties.setProperty("mail.smtp.host",HOST);

        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL_FROM,PASSWORD);
            }
        });
        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_FROM));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(EMAIL_TO));
            message.setSubject("Mail theme");

            DataSource dataSource = new FileDataSource(new File(filePath + fileName));
            DataHandler dataHandler = new DataHandler(dataSource);
            message.setDataHandler(dataHandler);
            message.setFileName(fileName);

            Transport.send(message);
            System.out.println("Email send");

        }catch (MessagingException e){
            e.printStackTrace();
        }

    }
}
