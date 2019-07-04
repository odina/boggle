# Boggle API + App

### Setting Up Locally

```
1. Make sure you have ruby 2.5.5 installed (preferrably by rvm or rbenv)
2. Run `bundle install`
3. Run `bin/rake db:create`
4. Run `bin/rake db:migrate`
5. Run `bin/rails server`
```

### Rough overview of structure and files:

#### Files

```
- BOGGLE_TREE is declared in config/initializers/boggle_tree.rb This gives the global
  constant BOGGLE_TREE, which is a hash of all the valid words in lib/dictionary.txt
  e.g.
       d
     / |
    a  o
   /   |\
  d    g o
          \
           r
- Board logic is housed inside lib/board.rb
- Everytime a word is searched for a game, a board is created, and the search algorithm
  is run for the existence of the word on the board as well as the existence of the word
  in the dictionary.txt file
```

#### Structure

```
- app/interactors - Added play_boggle.rb to this folder because this is a business logic
                  - interactors taken from brilliant gem https://github.com/collectiveidea/interactor
```

### Running tests

```
1. Make sure test db is up-to-date with `RAILS_ENV=test bin/rake db:migrate`
2. Run `rspec -fd spec` to run the full test suite
```

### TODO

```
- `found_words` inside game_results is limited to the max size of `text`, about
  30,000 characters. Decided to go this route to simplify the db structure.
- Needs minimum proper authentication (client registration + token maybe), for now
  only set to basic auth
```

### Accessing the app in live

[Click Here](https://nameless-wildwood-56391.herokuapp.com) to access a demo version of the app

### Accessing API in live

##### NOTE: I added basic auth for the API calls (production only), will provide the username and password in a separate email

#### POST /games

```
curl -X POST 'https://nameless-wildwood-56391.herokuapp.com/api/v1/games' -d 'duration=7200' -d 'random=true' -u username:password
```

#### GET /games/:id

```
curl -X GET 'https://nameless-wildwood-56391.herokuapp.com/api/v1/games/1' -u username:password
```

#### PUT /games/:id

```
curl -X PUT 'https://nameless-wildwood-56391.herokuapp.com/api/v1/games/1' -d 'word=yacht' -d 'token=24564478e7387f1cfa02c228893c54cc' -u username:password
```

### Architecture used

![Boggle ERD](https://github.com/odina/boggle/blob/master/public/readme/boggle-erd.png)

### Screenshots

![alt tag](https://github.com/odina/boggle/blob/master/public/readme/ss-1.png)
![alt tag](https://github.com/odina/boggle/blob/master/public/readme/ss-2.png)
![alt tag](https://github.com/odina/boggle/blob/master/public/readme/ss-3.png)
