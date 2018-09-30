module Transactions
  ##
  # A transaction accepting parameters that pass {Validator::CreateSubscription}[rdoc-ref:Validator::CreateSubscription]
  # validator and returns a dummy value simulating subscription creation.
  #
  class CreateSubscription < Base
    step :validate
    step :build

    private

    def validate(params)
      Validators::CreateSubscription.new(params).validate
    end

    def build(params)
      Success({:subscription => {:dummy => true}})
    end
  end
end
