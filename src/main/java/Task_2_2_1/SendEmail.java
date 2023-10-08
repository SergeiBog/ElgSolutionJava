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

    public void sendEmail(String filePath, String fileName){
        Properties properties = new Properties();
        properties.put("mail.smtp.host", "smtp.mail.ru");
        properties.put("mail.smtp.port", "465");
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");
        properties.put("mail.smtps.ssl.checkserveridentity", true);
        properties.put("mail.smtps.ssl.trust", "*");
        properties.put("mail.smtp.ssl.enable", "true");

        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL_FROM,PASSWORD);
            }
        });
        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_FROM));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(EMAIL_TO));
            message.setSubject("Subject email");

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
