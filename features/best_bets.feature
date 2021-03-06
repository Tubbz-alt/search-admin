Feature: Best bets
  As a search admin
  I want to be able to provide hints to our search system
  So that better results are provided to the users

  @stub_best_bets
  Scenario: Admin user creating best bets
    Given I am an admin user
    When I create a best bet as an admin
    Then the query should be listed on the index page
    And the best bet should be listed on the query page

  @stub_best_bets
  Scenario: Admin user editing best bets
    Given I am an admin user
    Given a query exists
    When I edit a best bet as an admin
    Then the edited best bet should be listed on the query page

  @stub_best_bets
  Scenario: Admin user deleting best bets
    Given I am an admin user
    Given a query exists
    When I delete the first best bet
    Then the best bet should not be listed on the query page

    @stub_best_bets
    Scenario: Basic user creating best bets
      Given I am a basic user
      When I create a best bet
      Then the query should be listed on the index page
      And the best bet should be listed on the query page

    @stub_best_bets
    Scenario: Basic user editing best bets
      Given I am a basic user
      Given a query exists
      When I edit a best bet
      Then the edited best bet should be listed on the query page

    @stub_best_bets
    Scenario: Basic user deleting best bets
      Given I am a basic user
      Given a query exists
      When I delete the first best bet
      Then the best bet should not be listed on the query page
