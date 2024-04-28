Feature: User Login Functionality

  Scenario: Successful login with valid credentials
    Given the login page is open
    When the user enters the username "<up12344@up.pt>"
    And the user enters the password "<teste>"
    And the user presses the login button
    Then the user is redirected to the Geolocation screen


  Scenario: Unsuccessful login with invalid credentials
      Given the login page is open
      When the user enters the username "up12344@example.com"
      And the user enters the password "incorrect"
      And presses the login button
      Then the user should see an error message

   Scenario: Unsuccessful login with empty credentials
      Given the login page is open
      When the user enters the username ""
      And the user enters the password ""
      And presses the login button
      Then the user should see an error message

