import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

public class EmailUtil {

    private static final String FROM_EMAIL = "dhadgeashish@gmail.com";
    private static final String PASSWORD = "zqhigzswygybtbre";
    /* ================= BASIC EMAIL ================= */
    public static void sendSimpleMail(String to, String subject, String messageText)
            throws Exception {

        Properties props = new Properties();    
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props,
            new javax.mail.Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(FROM_EMAIL, PASSWORD);
                }
            });

        Message msg = new MimeMessage(session);
        msg.setFrom(new InternetAddress(FROM_EMAIL));
        msg.setRecipients(Message.RecipientType.TO,
                InternetAddress.parse(to));
        msg.setSubject(subject);
        msg.setText(messageText);

        Transport.send(msg);
    }

    /* ================= ORDER CONFIRMATION EMAIL ================= */
    public static void sendOrderEmail(String to, int orderId,
                                      double total, String productDetails)
            throws Exception {

        String message =
                "Dear Customer,\n\n" +
                "Thank you for shopping with Beauty Hub Cosmetics!\n\n" +
                "Your order has been successfully placed.\n\n" +
                "Order ID : " + orderId + "\n\n" +

                "Product Details:\n" +
                "------------------------------------------\n" +
                productDetails +
                "------------------------------------------\n\n" +

                "Total Amount :  " + total + "\n\n" +

                "Our team is preparing your items and you will be notified once your order is Deliverd.\n\n" +

                "We truly appreciate your trust in us and look forward to serving you again.\n\n" +

                "Warm Regards,\n" +
                "Beauty Hub Cosmetics Team\n" +
                "Customer Support: support@beautyhub.com\n";

        sendSimpleMail(
                to,
                "Order Confirmation - Beauty Hub Cosmetics (Order ID: " + orderId + ")",
                message
        );
    }
}