defmodule Wow.AuctionEntry do
  use Ecto.Schema
  import Ecto.Changeset

  @type raw_entry :: %{optional(String.t) => String.t}
  @type t :: Ecto.Schema.t

  @primary_key {:id, :id, autogenerate: true}

  schema "auction_entry" do
    field :auc_id, :integer
    field :bid, :integer
    field :item, :integer
    field :owner, :string
    field :owner_realm, :string
    field :buyout, :integer
    field :quantity, :integer
    field :time_left, :string
    field :rand, :integer
    field :seed, :integer
    field :context, :integer
    field :dump_timestamp, :utc_datetime

    timestamps()
  end

  @spec changeset(Wow.AuctionEntry.t, map) :: Ecto.Changeset.t
  def changeset(entry, params \\ %{}) do
    entry
    |> cast(params, [:auc_id, :bid, :item, :owner, :owner_realm, :buyout, :quantity, :time_left, :rand, :seed, :context,
                    :dump_timestamp]
    )
    |> validate_required([:auc_id, :bid, :item, :owner, :owner_realm, :buyout, :quantity, :time_left, :rand, :seed,
                         :context, :dump_timestamp]
    )
    |> unique_constraint(:auc_id_dump_timestamp)
  end

  @spec from_raw(raw_entry, integer) :: t
  def from_raw(auction, timestamp) do
    %Wow.AuctionEntry{
      auc_id: auction["auc"],
      bid: auction["bid"],
      item: auction["item"],
      owner: auction["owner"],
      owner_realm: auction["ownerRealm"],
      buyout: auction["buyout"],
      quantity: auction["quantity"],
      time_left: auction["timeLeft"],
      rand: auction["rand"],
      seed: auction["seed"],
      context: auction["context"],
      dump_timestamp: timestamp |> DateTime.from_unix!(:millisecond) |> DateTime.truncate(:second)
    } |> changeset
  end
end
