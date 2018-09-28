require "dry-struct"
require "money"

module FakePay
  module Types
    include Dry::Types.module
  end

  class CardDetailsPurchaseRequest < Dry::Struct
    attribute :amount,           Types.Instance(Money)
    attribute :card_number,      Types::Strict::String
    attribute :security_code,    Types::Strict::String
    attribute :expiration_month, Types::Strict::Integer
    attribute :expiration_year,  Types::Strict::Integer
    attribute :zip_code,         Types::Strict::String
  end

  class CardTokenPurchaseRequest < Dry::Struct
    attribute :amount,     Types.Instance(Money)
    attribute :card_token, Types::Strict::String
  end

  class PurchaseResponse < Dry::Struct
    attribute :card_token, Types::Strict::String
  end
end
