# MWSClient

** An Elixir client for accessing Amazon's Merchant Web Services **

Inspired by ruby https://github.com/hakanensari/peddler gem api and 
elixir https://github.com/zachgarwood/elixir-amazon-product-advertising-client for signature signing.

Only implemented APIs for what I needed, other API's need to be ported as I go along.

## Usage:

  1. Fill out a %MWSClient.Config struct that holds credentials needed for signature creation.

  ```elixir
    config = %MWSClient.Config{aws_access_key_id: ..., mws_auth_token: ...}
  ```

  2. An api call is done in two parts, the operation piped to the request

  ```elixir
  MWSClient.Products.get_matching_product(["B00KO1C94A"]) |> MWSClient.request(config)
  ```

  The first part creates an %MWSClient.Operation struct holding basic parts of the API call,
  e.g map of parameters to send, the path, the method.

  The second part the MWSClient.request appends additional parameters from your config struct, creates a signature and makes the API call.  The result is a %HTTPoison{} struct.

  3. Pipe that into a parser to facilitate enumerating over csv or xml response body.

  ```elixir
  MWSClient.Products.get_matching_product(["B00KO1C94A"]) |> MWSClient.request(config)
   |> MWSClient.Parse.parse
  ```

  MWSClient.Parser.parse determines the enumerable based on the response header content-type.

========
TODO:
file upload


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `mws_client` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:mws_client, "~> 0.0.1"}]
    end
    ```

  2. Ensure `mws_client` is started before your application:

    ```elixir
    def application do
      [applications: [:mws_client]]
    end
    ```

