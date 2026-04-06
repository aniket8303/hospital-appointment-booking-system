package com.hospital.util;

import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

public class HibernateUtil {

    private static SessionFactory factory;

    static {
        try {
            factory = new Configuration().configure().buildSessionFactory();
            System.out.println("Hibernate SessionFactory created successfully.");
        } catch (Exception e) {
            System.err.println("SessionFactory creation failed: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static SessionFactory getSessionFactory() {
        return factory;
    }

    public static void shutdown() {
        if (factory != null) factory.close();
    }
}
