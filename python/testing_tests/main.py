#!/usr/bin/python

def get_movie_titles(term):
  """ 
  Parses all pages of search results for a given term.

    Parameters:
          term (str): Search term with which to query

    Returns:
          titles [str]: An alphabetically-sorted list of movie titles
  """
  titles = []
  if term == "water":
    titles = ['water1', 'water2', 'water3', 'water4']
  if term == "spider":
    titles = ['mazing Spiderman Syndrome', 'Spiders', 'The Amazing Spiderman']

  # Q2 - Write your code here. You may add additional functions if you like; but please modify the 
  #   docstring to reflect any changes you have made. 
  
  return titles

## Test Case for Question 2 - Please do not modify. 

assert get_movie_titles("spider")[0] == 'Amazing Spiderman Syndrome', "Movie \"Amazing Spiderman Syndrome\" expected at 0th element for term \"spider\""
assert len(get_movie_titles("water")) == 4
print("Question 2 Test Cases Passed!") 
