defmodule ArrgWeb.StorageSettingsLiveTest do
  use ArrgWeb.ConnCase

  import Phoenix.LiveViewTest
  import Arrg.StorageFixtures

  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_file_system(_) do
    %{file_system: insert(:file_system)}
  end

  describe "Index" do
    setup [:create_file_system]

    test "lists all file systems", %{conn: conn, file_system: file_system} do
      {:ok, _index_live, html} = live(conn, ~p"/settings/storage")

      assert html =~ "Storage"
      assert html =~ file_system.name
    end

    test "saves new file systems", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/settings/storage")

      {:ok, index_live, _html} =
        index_live
        |> element("a", "New storage")
        |> render_click()
        |> follow_redirect(conn, ~p"/settings/storage/new")

      assert index_live
             |> form("#file-system-form", file_system: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#file-system-form", file_system: params_for(:file_system, name: "some name"))
             |> render_submit()

      assert_patch(index_live, ~p"/settings/storage")

      html = render(index_live)
      assert html =~ "some name"
    end

    test "updates file system in listing", %{conn: conn, file_system: file_system} do
      {:ok, index_live, _html} = live(conn, ~p"/settings/storage")

      {:ok, index_live, _html} =
        index_live
        |> element("#file-system-#{file_system.name} a", "Edit")
        |> render_click()
        |> follow_redirect(conn, ~p"/settings/storage/#{file_system}/edit")

      assert index_live
             |> form("#file-system-form", file_system: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#file-system-form", file_system: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/settings/storage")

      html = render(index_live)
      assert html =~ @update_attrs[:name]
    end

    test "deletes file system in listing", %{conn: conn, file_system: file_system} do
      {:ok, index_live, _html} = live(conn, ~p"/settings/storage")

      assert index_live |> element("#file-system-#{file_system.name} button", "Delete") |> render_click()
      refute has_element?(index_live, "#file-system-#{file_system.name}")
    end
  end

  describe "Show" do
    setup [:create_file_system]

    test "displays file system data", %{conn: conn, file_system: file_system} do
      {:ok, _show_live, html} = live(conn, ~p"/settings/storage/#{file_system}")

      assert html =~ "Storage: #{file_system.name}"
      assert html =~ file_system.name
      assert html =~ file_system.implementation.root
    end

    test "updates file system within modal", %{conn: conn, file_system: file_system} do
      {:ok, show_live, _html} = live(conn, ~p"/settings/storage/#{file_system}")

      {:ok, show_live, _html} =
        show_live
        |> element("a", "Edit")
        |> render_click()
        |> follow_redirect(conn, ~p"/settings/storage/#{file_system}/show/edit")

      assert show_live
             |> form("#file-system-form", file_system: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#file-system-form", file_system: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/settings/storage/#{@update_attrs[:name]}")

      html = render(show_live)
      assert html =~ "some updated name"
    end
  end
end
