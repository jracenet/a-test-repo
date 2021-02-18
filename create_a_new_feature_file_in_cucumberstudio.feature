Feature: Create a new feature file in CucumberStudio
  
  Scenario: the feature does not exist
    When I save the feature in the selected repository
    Then the feature should appear in the repository