package com.campusworks.eureka;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.server.EnableEurekaServer;

/**
 * Eureka Server Application
 * Service Discovery and Registration Hub for CampusWorks Microservices
 */
@SpringBootApplication
@EnableEurekaServer
public class EurekaServerApplication {
    
    public static void main(String[] args) {
        SpringApplication.run(EurekaServerApplication.class, args);
        System.out.println("🚀 Eureka Server started successfully!");
        System.out.println("📱 Dashboard: http://localhost:8761");
    }
}
