defmodule KVStats do
  @moduledoc """
  Our wrapper around the Statix Statsd client.  the `use Statix` below imports the statsd functions.

  See docs for details.
  """

  use Statix, runtime_config: true
end
