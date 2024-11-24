package com.example.demo;

import javafx.application.Application;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.PasswordField;
import javafx.scene.control.TextField;
import javafx.stage.Stage;
import javafx.stage.StageStyle;

import java.io.IOException;
import java.sql.Connection;

import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ConcurrentModificationException;
import java.util.EventObject;

public class HelloController {

    private Stage stage;
    private Scene scene;

    @FXML
    private Button cancelButton;
    @FXML
    private Label loginMessageLabel;

    @FXML
    private Button loginButton;
    @FXML
    private TextField usernameTextfield;
    @FXML
    private PasswordField passwordPasswordfield;


    @FXML
    public void loginButtonOnAction(ActionEvent e) throws IOException {
        if (!usernameTextfield.getText().isBlank() && !passwordPasswordfield.getText().isBlank()) {
            /*
                      Validation BDD
             validateLogin();
                        loginMessageLabel.setText("You try to login!");
            */
            FXMLLoader fxmlLoader = new FXMLLoader(Application.class.getResource("dashboard.fxml"));
            Scene scene = new Scene(fxmlLoader.load(), 900, 600);
            stage=(Stage)((Node)e.getSource()).getScene().getWindow();
            //stage.initStyle(StageStyle.UNDECORATED);
            stage.setTitle("Dashboard");
            stage.setScene(scene);
            stage.show();
        } else {
            loginMessageLabel.setText("Please enter username and password!");
        }
    }
    @FXML
    public void cancelButtonOnAction(ActionEvent e) {
        Stage stage=(Stage) cancelButton.getScene().getWindow();
        stage.close();
    }
    public void validateLogin() {
        DatabaseConnection connectNow = new DatabaseConnection();
        Connection connectDB = connectNow.getConnection();

        String verifyLogin="SELECT Count(0) FROM public.\"utilisateur\" WHERE \"nom_utilisateur\"='" +
                usernameTextfield.getText() + "' AND \"mot_de_passe\"='" +
                passwordPasswordfield.getText() + "';";

        try {
            Statement statement = connectDB.createStatement();
            ResultSet queryResult = statement.executeQuery(verifyLogin);

            while (queryResult.next()) {
                if (queryResult.getInt(1) ==1) {
                    loginMessageLabel.setText("Bienvenu à l'application");
                } else {
                    loginMessageLabel.setText("Login invalide. Veuillez re-essayer.");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}