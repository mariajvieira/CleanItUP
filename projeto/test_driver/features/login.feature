Feature: Login functionality

  Scenario: User logs in with valid credentials
    Given the login page is open
    When the user enters valid credentials
    Then the user is redirected to the homepage
