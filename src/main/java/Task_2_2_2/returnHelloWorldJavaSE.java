package Task_2_2_2;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpServer;

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;

public class returnHelloWorldJavaSE {
    public static void main(String[] args) throws IOException {
        HttpServer httpServer = HttpServer.create();

        httpServer.bind(new InetSocketAddress(8080),0);
        httpServer.createContext("/", new HttpHandler() {
            @Override
            public void handle(HttpExchange exchange) throws IOException {
                String response = "Hello world";
                exchange.sendResponseHeaders(200,0);
                try (OutputStream outputStream = exchange.getResponseBody()){
                    outputStream.write(response.getBytes());
                }
            }
        });

        httpServer.start();
    }
}
