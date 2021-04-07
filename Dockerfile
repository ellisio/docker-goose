FROM circleci/golang

# Install Postgres
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add - \
    && echo "deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main" | sudo tee  /etc/apt/sources.list.d/pgdg.list \
    && sudo apt update \
    && sudo apt install -y postgresql-client-13 \
    && sudo rm -rf /var/lib/apt/lists/*

# Install Goose
RUN go get -u github.com/pressly/goose/cmd/goose

# Install Elixir
RUN wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb \
    && sudo dpkg -i erlang-solutions_1.0_all.deb \
    && sudo apt update \
    && sudo apt install -y esl-erlang elixir \
    && sudo rm -rf /var/lib/apt/lists/*
