defmodule Arrg.StorageFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities for the `Arrg.Storage` context.
  """

  use Arrg.ExMachina.Ecto, repo: Arrg.Repo

  def file_system_factory do
    %Arrg.Storage.FileSystem{
      name: sequence(:name, &"test-file-system-#{&1}"),
      type: sequence(:type, ~w(movies shows music)a),
      implementation: build(:local_implementation)
    }
  end

  def local_implementation_factory do
    %Arrg.Storage.LocalImplementation{
      root: "/tmp"
    }
  end

  def file_factory do
    %Arrg.Storage.File{
      file_system: build(:file_system),
      path: sequence(:path, &"/test-path-#{&1}")
    }
  end
end
