defmodule AviutlScripts.ScriptManager do
  @moduledoc """
  The ScriptManager context.
  """

  import Ecto.Query, warn: false
  import Ecto.SoftDelete.Query
  alias AviutlScripts.Repo

  alias AviutlScripts.ScriptManager.Script

  @per_page 5

  def paginate_scripts(%{after: after_cursor}) do
    query = from(t in Script, order_by: [asc: t.inserted_at, asc: t.id])

    query
    |> with_undeleted
    |> Repo.paginate(after: after_cursor, cursor_fields: [:inserted_at, :id], limit: @per_page)
  end

  def paginate_scripts(%{before: before_cursor}) do
    query = from(t in Script, order_by: [asc: t.inserted_at, asc: t.id])

    query
    |> with_undeleted
    |> Repo.paginate(
      before: before_cursor,
      cursor_fields: [:inserted_at, :id],
      limit: @per_page
    )
  end

  def paginate_scripts(_) do
    query =
      from t in Script,
        order_by: [asc: t.inserted_at, asc: t.id]

    query
    |> with_undeleted
    |> Repo.paginate(cursor_fields: [:inserted_at, :id], limit: @per_page)
  end

  @doc """
  Returns the list of scripts.

  ## Examples

  iex> list_scripts()
  [%Script{}, ...]

  """
  def list_scripts do
    Script
    |> with_undeleted
    |> Repo.all()
  end

  @doc """
  Gets a single script.

  Raises `Ecto.NoResultsError` if the Script does not exist.

  ## Examples

  iex> get_script!(123)
  %Script{}

  iex> get_script!(456)
  ** (Ecto.NoResultsError)

  """
  def get_script!(id) do
    Script
    |> where([s], s.id == ^id)
    |> with_undeleted
    |> Repo.one()
  end

  @doc """
  Creates a script.

  ## Examples

  iex> create_script(%{field: value})
  {:ok, %Script{}}

  iex> create_script(%{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def create_script(attrs \\ %{}) do
    %Script{}
    |> Script.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a script.

  ## Examples

  iex> update_script(script, %{field: new_value})
  {:ok, %Script{}}

  iex> update_script(script, %{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def update_script(%Script{} = script, attrs) do
    script
    |> Script.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a script.

  ## Examples

  iex> delete_script(script)
  {:ok, %Script{}}

  iex> delete_script(script)
  {:error, %Ecto.Changeset{}}

  """
  def delete_script(%Script{} = script) do
    Repo.soft_delete(script)
    |> IO.inspect()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking script changes.

  ## Examples

  iex> change_script(script)
  %Ecto.Changeset{data: %Script{}}

  """
  def change_script(%Script{} = script, attrs \\ %{}) do
    Script.changeset(script, attrs)
  end
end
