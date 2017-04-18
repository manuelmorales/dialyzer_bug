defmodule DialyzerBug do
  def make_request do
    HTTPoison.get(1,2,3)
  end
end
