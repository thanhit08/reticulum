import Config

config :ret, RetWeb.Plugs.PostgrestProxy,
  hostname: System.get_env("POSTGREST_INTERNAL_HOSTNAME", "localhost")

case config_env() do
  :dev ->
    db_hostname = System.get_env("DB_HOST", "localhost")
    dialog_hostname = System.get_env("DIALOG_HOSTNAME", "dev-janus.reticulum.io")
    hubs_admin_internal_hostname = System.get_env("HUBS_ADMIN_INTERNAL_HOSTNAME", "localhost")
    hubs_client_internal_hostname = System.get_env("HUBS_CLIENT_INTERNAL_HOSTNAME", "localhost")
    spoke_internal_hostname = System.get_env("SPOKE_INTERNAL_HOSTNAME", "localhost")
    dev_janus_host = "localhost"

    dialog_port =
      "DIALOG_PORT"
      |> System.get_env("443")
      |> String.to_integer()

    perms_key =
      "PERMS_KEY"
      |> System.get_env("")
      |> String.replace("\\n", "\n")

    # config :ret, Ret.JanusLoadStatus, default_janus_host: dialog_hostname, janus_port: dialog_port
    config :ret, Ret.JanusLoadStatus, default_janus_host: dev_janus_host, janus_port: 4443

    config :ret, Ret.Locking,
      session_lock_db: [
        database: "ret_dev",
        hostname: db_hostname,
        password: "postgres",
        username: "postgres"
      ]

    config :ret, Ret.PermsToken, perms_key: "-----BEGIN RSA PRIVATE KEY-----\nMIICXAIBAAKBgQDIdGIg86EGEvaofD8qyNio/YKEg7o8ZR6aXXIjwAr6HafxTMp/\nruSBICuy/ERj8Yb47Ue5RWCg/bkMoF+ykkOTMg3YdKU5fRi05hl+nmf95gA0OlUu\nFSTEXfdG0I2kaCKUaVhatg3AaPKhbUFKfPx9NKCgNdCGP5NFOeB2aS+0dwIDAQAB\nAoGAJuyimW91ly5bg0ANLAuwNrBzhbPmmA+yr5rxrQt/li3oDK0yrTSS3pgWpDzk\nMtwVr4Sz5sAYEWrzYgZKTuyj/js4TiGB5rXjuQ9mHFu1zstGCOeTdEqrMOO8hbCk\ngb1T/bfmZRm1PuF84VSk5MKeKzQILJSD0XVbcqO7aEZhNnECQQDpOOH6shhsHlAM\nuc0wRscxaRMahLK0T14v1w84MqfCTego/IT2zZBSsLjtq5geOpXPJMtCHi0b3mB1\n4niqYDkFAkEA3Ag7cFVfbllne13tgEVz/4bpfYySbdbQ8FclbUMpWXmGZQxvmC2M\nXaKHye4ZiU4JoVzCjUGoQNtlcih6BzMASwJAIjD8sEw72F35TmRO+Kzntw64hkK+\nEEEyhcD5sjt67LmPN7MNq0Enz3epJO7rNkNQgzXZtq/F3TgU3DN/jTreIQJAfovN\ng6HWLOUGexFeUvOe70tsZmS+oqV1rYSxZdHGqksWXG92jxNDM2cSqbRiw3E6YK+0\nxQEJ/6MvCST2acWPWQJBAKPkA9Swz98tzewuMAL2NHCUhFm/kB8mflwI11BwG8pl\nXjoXYC74zUEZLyaZ8LzOESaqtdsb/dEEmSRVcZ0wVt4=\n-----END RSA PRIVATE KEY-----"

    config :ret, Ret.PageOriginWarmer,
      admin_page_origin: "https://#{hubs_admin_internal_hostname}:8989",
      hubs_page_origin: "https://#{hubs_client_internal_hostname}:8080",
      spoke_page_origin: "https://#{spoke_internal_hostname}:9090"

    config :ret, Ret.Repo, hostname: db_hostname

    config :ret, Ret.SessionLockRepo, hostname: db_hostname

  :test ->
    db_credentials = System.get_env("DB_CREDENTIALS", "admin")
    db_hostname = System.get_env("DB_HOST", "localhost")

    config :ret, Ret.Repo,
      hostname: db_hostname,
      password: db_credentials,
      username: db_credentials

    config :ret, Ret.SessionLockRepo,
      hostname: db_hostname,
      password: db_credentials,
      username: db_credentials

    config :ret, Ret.Locking,
      session_lock_db: [
        database: "ret_test",
        hostname: db_hostname,
        password: db_credentials,
        username: db_credentials
      ]

  _ ->
    :ok
end
