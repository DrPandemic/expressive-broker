defmodule Wow.Jobs.CharacterFetch do
  alias Wow.Character
  alias Wow.Crawler
  alias Wow.Repo
  import Wow.Helpers, only: [with_logs: 1]
  use Toniq.Worker, max_concurrency: 5

  @spec perform([{:character_name, String.t}, {:realm_name, String.t}, {:region, String.t}]) :: :ok
  def perform(options) do
    %{character_name: character_name, realm_name: realm, region: region} = Enum.into(options, %{})
    with_logs(fn ->
      IO.puts "Starting character fetch for #{character_name}"
      character = Character.find_by_name_realm(character_name, realm, region)
      id = System.get_env("BLIZZARD_CLIENT_ID")
      secret = System.get_env("BLIZZARD_CLIENT_SECRET")

      case Crawler.get_access_token(id, secret) |> Crawler.get_character(options) do
        :not_found ->
          character = Ecto.Changeset.change(character, not_found: true)
          case Repo.update(character) do
            {:ok, _}       ->
              IO.puts "#{character_name} not found!"
            {:error, _}    ->
              IO.puts "Failed to update not found #{character_name}"
          end
          :ok
        raw ->
          character = Ecto.Changeset.change(character, faction: Map.get(raw, "faction"))
          case Repo.update(character) do
            {:ok, _}       ->
              IO.puts "Done with #{character_name}"
            {:error, _}    ->
              IO.puts "Failed to update #{character_name}"
          end

          :ok
      end
    end)
  end
end
