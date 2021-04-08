FROM circleci/golang

# Install Postgres
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add - \
    && echo "deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main" | sudo tee  /etc/apt/sources.list.d/pgdg.list \
    && sudo apt update \
    && sudo apt install -y postgresql-client-13 \
    && sudo rm -rf /var/lib/apt/lists/*

# Install Go Dependencies
ENV PATH="/root/go/bin:${PATH}"

RUN go get -u github.com/pressly/goose/cmd/goose \
    && go get gotest.tools/gotestsum

# Install Elixir
RUN wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb \
    && sudo dpkg -i erlang-solutions_1.0_all.deb \
    && sudo apt update \
    && sudo apt install -y esl-erlang elixir=1.10.1-1 \
    && sudo rm -rf /var/lib/apt/lists/*

# Installs Swagger
RUN sudo apt update \
    && sudo apt install jq \
    && sudo rm -rf /var/lib/apt/lists/* \
    && export DOWNLOAD_URL=$(curl -s https://api.github.com/repos/go-swagger/go-swagger/releases/latest | jq -r '.assets[] | select(.name | contains("'"$(uname | tr '[:upper:]' '[:lower:]')"'_amd64")) | .browser_download_url') \
    && sudo curl -o /usr/local/bin/swagger -L'#' "${DOWNLOAD_URL}" \
    && sudo chmod +x /usr/local/bin/swagger