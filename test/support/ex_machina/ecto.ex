defmodule Arrg.ExMachina.Ecto do
  @moduledoc """
  A wrapper around ExMachina that includes a patched version of
  the ecto strategy that supports PolymorphicEmbed.
  """

  defmacro __using__(opts) do
    quote do
      use ExMachina
      use Arrg.ExMachina.EctoStrategy, repo: unquote(Keyword.get(opts, :repo))

      def params_for(factory_name, attrs \\ %{}) do
        __MODULE__
        |> ExMachina.Ecto.params_for(factory_name, attrs)
        |> Enum.map(fn
          {k, v} when is_struct(v) -> {k, Map.from_struct(v)}
          other -> other
        end)
        |> Map.new()
      end

      def string_params_for(factory_name, attrs \\ %{}) do
        ExMachina.Ecto.string_params_for(__MODULE__, factory_name, attrs)
      end

      def params_with_assocs(factory_name, attrs \\ %{}) do
        __MODULE__
        |> ExMachina.Ecto.params_with_assocs(factory_name, attrs)
        |> Enum.map(fn
          {k, v} when is_struct(v) -> {k, Map.from_struct(v)}
          other -> other
        end)
        |> Map.new()
      end

      def string_params_with_assocs(factory_name, attrs \\ %{}) do
        ExMachina.Ecto.string_params_with_assocs(__MODULE__, factory_name, attrs)
      end
    end
  end
end
