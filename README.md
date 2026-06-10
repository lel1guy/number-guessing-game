# Number Guessing Game

**freeCodeCamp Relational Database Certification** — Project

A Bash-based number guessing game with PostgreSQL. Users enter a username, guess a randomly generated number between 1 and 1000, and receive feedback on each guess.

---

## Features

- **Returning user recognition** — greets returning players with their stats (games played, best score)
- **Auto-registration** — creates new user records on first visit
- **Input validation** — rejects non-integer guesses and re-prompts
- **Hint system** — tells the player if their guess was too high or too low
- **Game tracking** — records every game in the database with guess count
- **Stat tracking** — updates best score dynamically per user

## Technologies

| Tech | Purpose |
|------|---------|
| PostgreSQL | Relational database (2 tables: users, games) |
| Bash | Scripting language for the game loop |
| psql | PostgreSQL's native CLI client |

## Database Schema

```
number_guess
+-- users
|   +-- user_id       SERIAL PRIMARY KEY
|   +-- username      VARCHAR(22) UNIQUE NOT NULL
|   +-- games_played  INT DEFAULT 0
|   +-- best_game     INT
+-- games
    +-- game_id       SERIAL PRIMARY KEY
    +-- user_id       INT -> users(user_id)
    +-- guesses       INT NOT NULL
    +-- secret_number INT NOT NULL
```

## How to Run

```bash
# 1. Create and restore the database
psql -U postgres -c "CREATE DATABASE number_guess;"
psql -U postgres -d number_guess -f number_guess.sql

# 2. Run the game
chmod +x number_guess.sh
./number_guess.sh
```

### Sample Session

```
Enter your username:
vitor
Welcome, vitor! It looks like this is your first time here.
Guess the secret number between 1 and 1000:
500
It's lower than that, guess again:
750
It's higher than that, guess again:
625
It's lower than that, guess again:
abc
That is not an integer, guess again:
618
You guessed it in 5 tries. The secret number was 618. Nice job!
```

Returning users get a different greeting:

```
Enter your username:
vitor
Welcome back, vitor! You have played 1 games, and your best game took 5 guesses.
```

## Files

| File | Description |
|------|-------------|
| number_guess.sh | The bash game script |
| number_guess.sql | PostgreSQL dump (schema + data + constraints) |
| README.md | This file |

## Certification

This project is part of freeCodeCamp's **Relational Database Certification**.
