
require "dry/monads/result"

##
# A backport of the +Result+ conversion module from +dry-validation+ +0.12.2+
# to avoid the deprecation warnings the version required by +hanami-validations+ triggers.
# It's basically just rename of (in Haskell-speak) +data Either a b = Left a | Right b+
# to +data Result a b = Failure a | Success b+.
#
Dry::Validation.register_extension(:monads) do
  module Dry
    module Validation
      class Result
        include Dry::Monads::Result::Mixin

        def to_monad(options = EMPTY_HASH)
          if success?
            Success(output)
          else
            Failure(messages(options))
          end
        end
        alias_method :to_either, :to_monad
      end
    end
  end
end
