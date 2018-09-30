require "hanami/validations/form"
require "carmen"

##
# Module containing all application validations.
#
module Validators
  ##
  # Base class for all application validations.
  #
  class Base
    include Hanami::Validations::Form

    Dry::Validation.load_extensions(:monads)

    predicate(:country?) do |value|
      not Carmen::Country.coded(value).nil?
    end

    predicate(:associated?) do |klass, value|
      klass.where(:id => value).any?
    end

    def validate
      super.to_either
    end
  end
end
