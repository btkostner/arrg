defmodule Arrg.Storage.FileType do
  @moduledoc """
  Helper functions related to file types.
  """

  @doc """
  Parses the magic number of a file and returns the file type.
  """
  @spec identify(binary()) :: String.t() | nil
  def identify(<<0x66, 0x4C, 0x61, 0x43>> <> _),
    do: "audio/x-flac"

  def identify(<<0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A>> <> _),
    do: "image/png"

  def identify(<<0xFF, 0xD8, 0xFF, 0xDB>> <> _),
    do: "image/jpeg"

  def identify(<<0xFF, 0xD8, 0xFF, 0xE0, 0x00, 0x10, 0x4A, 0x46, 0x49, 0x46, 0x00, 0x01>> <> _),
    do: "image/jpeg"

  def identify(<<0xFF, 0xD8, 0xFF, 0xEE>> <> _),
    do: "image/jpeg"

  def identify(<<0xFF, 0xD8, 0xFF, 0xE1, _, _, 0x45, 0x78, 0x69, 0x66, 0x00, 0x00>> <> _),
    do: "image/jpeg"

  def identify(<<0xEF, 0xBB, 0xBF>> <> _),
    do: "text/plain"

  def identify(bytes) when is_binary(bytes),
    do: "text/plain"

  def identify(_bytes), do: nil
end
