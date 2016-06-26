#API documentation for Bowling Game Score Board

- GET `/api/games/:id`

Will show details of `Game` with specified `id`

response: 
  HTTP OK 200
``` json
{
  "score": 42,
  "frame_number": 2,
  "game_over": false
}
```


- POST `/api/games`

Will create a new game and return it's `id`

response: 
  HTTP OK 201
``` json
{
  "id": 80
}
```


- PUT/PATCH `/api/games/:id`
    + body: `{ "knocked_pins": 4 }`

Will add the knocked down pins to the score and update the db record.

response: 
  HTTP OK 204
``` json
{ }
```

  HTTP OK 422
``` json
{
  "message": "Can't knock more pins than available."
}
```

  HTTP OK 422
``` json
{
  "message": "This game is over."
}
```
