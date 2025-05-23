# OrderedQueue

# get dependencies and compile

```bash
mix deps &&\
mix compile
```

# start

```bash
mix phx.server
```

# or start interactively with iex

```bash
iex -S mix phx.server
```

# add 

```bash
curl -X POST http://localhost:4000/api/messages \
  -H "Content-Type: application/json" \
  -d '{"user_id": "alice", "message": "first"}'

curl -X POST http://localhost:4000/api/messages \
  -H "Content-Type: application/json" \
  -d '{"user_id": "alice", "message": "second"}'
```

# dashboard

http://localhost:4000/dashboard