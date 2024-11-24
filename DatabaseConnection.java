package com.example.demo;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {

    public Connection databaselink;

    public Connection getConnection() {
        String databaseName ="ab_pharmagest";
        String databaseUser="postgres";
        String databasePassword="14598762";
        String url="jdbc:postgresql://localhost:5432/" + databaseName;


        try {
            Class.forName("org.postgresql.Driver");
            databaselink=DriverManager.getConnection(url,databaseUser,databasePassword);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return databaselink;
    }
}