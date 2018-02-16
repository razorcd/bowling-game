#API documentation for Bowling Game Score Board

- GET `/api/games/:id`

Will show details of `Game` with specified `id`

response: 
  HTTP OK 200
``` json
{
  "score": 42,
  "score_by_frame":[[4,4],[4,1],[7,3,2],[2]]
  "game_over": false
}
```


- POST `/api/games`

Will create a new game and return it's `id`

response: 
  HTTP 201 Created
``` json
{
  "id": 80
}
```


- PUT/PATCH `/api/games/:id`
    + body: `{ "knocked_pins": 4 }`

Will add the knocked down pins to the score and update the db record.

response: 
  HTTP 204 No Content
``` json
{ }
```

  HTTP 422 Unprocessable Entity
``` json
{
  "message": "Can't knock more pins than available."
}
```

  HTTP 422 Unprocessable Entity
``` json
{
  "message": "This game is over."
}
```
