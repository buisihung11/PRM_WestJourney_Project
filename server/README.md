# API LIST

## User

1. [x] Login
2. [ ] Logout

## Actor

1. [x] GET /me/scenes (?filter= ["done","not-yet","default"])
2. [x] GET /me/scenes/:id
3. [x] GET /me/scenes/:id/characters
4. [ ] GET /me/scenes/:id/characters/:characterId
5. [ ] GET /me/scenes/:id/characters/:characterId/download

## Admin

### 1. **Scenes**

1. [ ] GET,POST /scenes
2. [ ] PUT,DELETE /scenes/:id
4. [ ] GET, POST /scenes/:id/equipments (filter: ['status','date-time'])
5. [ ] PUT, DELETE /scenes/:id/equipments/:id
6. [ ] GET, POST /scenes/:id/characters
7. [ ] PUT, DELETE /scenes/:id/characters/:id

### 2. **Actors**

1. [ ] GET,POST /actors
2. [ ] PUT,DELETE /actors/:id

### 3. **Equipments**

1. [ ] GET,POST /equipments
2. [ ] PUT,DELETE /equipments/:id