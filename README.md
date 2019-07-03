# Boggle API + App

### Setting Up Locally

```
1. Make sure you have ruby 2.5.5 installed (preferrably by rvm or rbenv)
2. Run `bundle install`
3. Run `bin/rails server`
```

### Running tests

```
1. Make sure test db is up-to-date with `RAILS_ENV=test bin/rake db:migrate`
2. Run `rspec -fd spec` to run the full test suite
```

### Caveats

```
- API has no security yet, accepts all incoming requests
- `found_words` inside game_results is limited to the max size of `text`, about
  30,000 characters. Decided to go this route to simplify the db structure.
```

### Accessing the app in live

[Click Here](https://nameless-wildwood-56391.herokuapp.com) to access a demo version of the app

### Accessing API in live

#### POST /games

```
curl -X POST 'https://nameless-wildwood-56391.herokuapp.com/api/v1/games' -d 'duration=7200' -d 'random=true'
```

#### GET /games/:id

```
curl -X GET 'https://nameless-wildwood-56391.herokuapp.com/api/v1/games/1'
```

#### PUT /games/:id

```
curl -X PUT 'https://nameless-wildwood-56391.herokuapp.com/api/v1/games/1' -d 'word=yacht' -d 'token=24564478e7387f1cfa02c228893c54cc'
```

### Architecture used

![Boggle ERD](https://github.com/odina/boggle/blob/master/public/readme/boggle-erd.png)

### Screenshots

![alt tag](https://github.com/odina/boggle/blob/master/public/readme/ss-1.png)
![alt tag](https://github.com/odina/boggle/blob/master/public/readme/ss-2.png)
![alt tag](https://github.com/odina/boggle/blob/master/public/readme/ss-3.png)
