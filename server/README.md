# API LIST

## User

1. [x] Login
2. [ ] Logout

## Actor

1. [x] GET /me/scenes (?filter= ["done","not-yet","default"])
2. [x] GET /me/scenes/:id
3. [] GET /me/scenes/:id/characters (Deprecated)
4. [ ] GET /me/scenes/:id/characters/:characterId (Deprecated)
5. [ ] GET /me/scenes/:id/characters/:characterId/download (Deprecated)

## Admin

### 1. **Scenes**

1. [x] GET,POST /scenes
2. [x] GET,PUT,DELETE /scenes/:id
5. [x] GET, POST /scenes/:id/characters
6. [ ] PUT, POST /scenes/:id
7. [ ] Add quantity for ScenceEquipment table

### 2. **Actors**

1. [x] GET,POST /actors
2. [x] PUT,DELETE /actors/:id

### 3. **Equipments**

1. [x] GET,POST /equipments (?status= ["all","available","unavailable"])
2. [x] PUT,DELETE /equipments/:id