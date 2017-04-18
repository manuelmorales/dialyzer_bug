# DialyzerBug

This is a reproduction of a potential bug I submitted to Dialyxir:
https://github.com/jeremyjh/dialyxir/issues/88.
Use:

```
git clone git@github.com:manuelmorales/dialyzer_bug.git
mix deps.get
mix dialyzer
```

The issue is that Dialyxir doesn't seem to realize that I'm passing wrong arguments to HTTPoison.

```elixir
# dialyzer_bug/lib/dialyzer_bug.ex
defmodule DialyzerBug do
  def make_request do
    HTTPoison.get(1,2,3)
  end
end
```

This is wrong as HTTPoison specifies the expected arguments:

```elixir
# https://github.com/edgurgel/httpoison/blob/v0.11.0/lib/httpoison/base.ex#L190

@spec get(binary, headers, Keyword.t) :: {:ok, Response.t | AsyncResponse.t} | {:error, Error.t}
def get(url, headers \\ [], options \\ []),          do: request(:get, url, "", headers, options
```

However, Dialyzer passes:

```
$ mix dialyzer
Compiling 1 file (.ex)
Generated dialyzer_bug app
Checking PLT...
[:asn1, :certifi, :compiler, :crypto, :dialyxir, :elixir, :hackney, :httpoison,
 :idna, :kernel, :logger, :metrics, :mimerl, :public_key, :ssl, :ssl_verify_fun,
 :stdlib]
Finding suitable PLTs
Looking up modules in dialyxir_erlang-19.3_elixir-1.4.1_deps-dev.plt
Finding applications for dialyxir_erlang-19.3_elixir-1.4.1_deps-dev.plt
Finding modules for dialyxir_erlang-19.3_elixir-1.4.1_deps-dev.plt
Checking 548 modules in dialyxir_erlang-19.3_elixir-1.4.1_deps-dev.plt
Adding 6 modules to dialyxir_erlang-19.3_elixir-1.4.1_deps-dev.plt
Starting Dialyzer
dialyzer args: [check_plt: false,
 init_plt: '/home/manuel/ws/dialyzer_bug/_build/dev/dialyxir_erlang-19.3_elixir-1.4.1_deps-dev.plt',
 files_rec: ['_build/dev/lib/dialyzer_bug/ebin',
  '_build/dev/lib/httpoison/ebin'], warnings: [:unknown]]
done in 0m2.2s
done (passed successfully)
```

I also tried with  the following options on `mix.exs`:

```elixir
  def project do
    [
      ...
      dialyzer: [
        plt_add_deps: :transitive,
        paths: ["_build/dev/lib/dialyzer_bug/ebin", "_build/dev/lib/httpoison/ebin"]
      ]
    ]
  end
```
